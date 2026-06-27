# ============================================================
# LEPS CONTROL CENTER - Leoni Administration Core
# PowerShell WPF Application
# ============================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

# ── CONFIG ──────────────────────────────────────────────────
$CURRENT_USER = $env:USERNAME
$APP_VERSION  = "v1.0"
$DEPARTMENT   = "IT Department"

# Paths — adapt to your environment
$INSTALLATION_FOLDER = "\\ltn1-server\IT\LEPS\Installation"
$STARTUP_FOLDER      = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$IT_ADMIN_APP        = "\\ltn1-server\IT\Apps\ITAdministration.exe"
$LEPS_PRINT_APP      = "\\ltn1-server\IT\Apps\LEPSPrintingAdmin.exe"
$ISE_NAC_URL         = "https://vugblisepan01.leoni.local/admin/"

# Servers per site
$SERVERS = @{
    LTN1 = @("BZ", "MB", "MLB", "PORSCHE + LAMBO")
    LTN2 = @("HV", "V2L")
    LTN4 = @("G2X", "K8X", "SZ")
}

# ── XAML UI ─────────────────────────────────────────────────
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="LEPS Control Center"
        Width="1100" Height="720"
        WindowStartupLocation="CenterScreen"
        Background="#0D1117"
        FontFamily="Segoe UI">

    <Window.Resources>
        <Style x:Key="BtnBase" TargetType="Button">
            <Setter Property="Height" Value="42"/>
            <Setter Property="Margin" Value="0,5,0,5"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontFamily" Value="Segoe UI Semibold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                CornerRadius="6" Padding="10,0">
                            <ContentPresenter HorizontalAlignment="Center"
                                              VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Opacity" Value="0.85"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Opacity" Value="0.7"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="BtnBlue" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#3B7BF5"/>
            <Setter Property="Foreground" Value="White"/>
        </Style>
        <Style x:Key="BtnGreen" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#22C55E"/>
            <Setter Property="Foreground" Value="White"/>
        </Style>
        <Style x:Key="BtnDark" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#1E2530"/>
            <Setter Property="Foreground" Value="White"/>
        </Style>
        <Style x:Key="BtnServer" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#1E2530"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Height" Value="38"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="Padding" Value="12,0"/>
        </Style>
        <Style x:Key="TabBtn" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#8B9BB4"/>
            <Setter Property="Height" Value="36"/>
            <Setter Property="Padding" Value="18,0"/>
            <Setter Property="FontSize" Value="12"/>
        </Style>
        <Style x:Key="TabBtnActive" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#3B7BF5"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Height" Value="36"/>
            <Setter Property="Padding" Value="18,0"/>
            <Setter Property="FontSize" Value="12"/>
        </Style>
        <Style x:Key="SrvTabBtn" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#8B9BB4"/>
            <Setter Property="Height" Value="34"/>
            <Setter Property="Padding" Value="16,0"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="BorderBrush" Value="#2A3444"/>
        </Style>
        <Style x:Key="SrvTabBtnActive" TargetType="Button" BasedOn="{StaticResource BtnBase}">
            <Setter Property="Background" Value="#3B7BF5"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Height" Value="34"/>
            <Setter Property="Padding" Value="16,0"/>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#1E2530"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#3B7BF5"/>
            <Setter Property="BorderThickness" Value="1.5"/>
            <Setter Property="Padding" Value="8"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="60"/>
            <RowDefinition Height="50"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="30"/>
        </Grid.RowDefinitions>

        <Grid Grid.Row="0" Background="#0D1117">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <Border Grid.Column="0" Background="#3B7BF5" CornerRadius="6"
                    Width="36" Height="36" Margin="16,0,0,0" VerticalAlignment="Center">
                <TextBlock Text="L" Foreground="White" FontSize="20"
                           FontWeight="Bold" HorizontalAlignment="Center"
                           VerticalAlignment="Center"/>
            </Border>
            <TextBlock Grid.Column="0" Text="LEONI" Foreground="White"
                       FontSize="16" FontWeight="Bold" Margin="60,0,0,0"
                       VerticalAlignment="Center"/>
            <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                <TextBlock Text="LEPS CONTROL CENTER" Foreground="White"
                           FontSize="20" FontWeight="Bold" HorizontalAlignment="Center"/>
                <TextBlock Text="LEONI Administration Core" Foreground="#8B9BB4"
                           FontSize="11" HorizontalAlignment="Center"/>
            </StackPanel>
            <Border Grid.Column="2" Background="#1E2530" CornerRadius="20"
                    Padding="12,6" Margin="0,0,16,0" VerticalAlignment="Center">
                <StackPanel Orientation="Horizontal">
                    <Border Background="#3B7BF5" CornerRadius="14"
                            Width="28" Height="28" Margin="0,0,8,0">
                        <TextBlock x:Name="txtUserInitial" Text="R" Foreground="White"
                                   FontSize="13" FontWeight="Bold"
                                   HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>
                    <StackPanel VerticalAlignment="Center">
                        <TextBlock x:Name="txtUserName" Text="Rayan Gazzah"
                                   Foreground="White" FontSize="12" FontWeight="SemiBold"/>
                        <TextBlock Text="LEPS ADMINISTRATOR" Foreground="#3B7BF5"
                                   FontSize="9" FontWeight="Bold"/>
                    </StackPanel>
                </StackPanel>
            </Border>
        </Grid>

        <Border Grid.Row="1" Background="#0D1117"
                BorderBrush="#1E2530" BorderThickness="0,0,0,1">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="10,0">
                <Button x:Name="TabServers" Content="🌐  SERVERS"
                        Style="{StaticResource TabBtnActive}" Tag="Servers"/>
                <Button x:Name="TabLeps" Content="⚙  LEPS"
                        Style="{StaticResource TabBtn}" Tag="Leps"/>
                <Button x:Name="TabApps" Content="📋  APPS"
                        Style="{StaticResource TabBtn}" Tag="Apps"/>
                <Button x:Name="TabQR" Content="📷  QR CODE"
                        Style="{StaticResource TabBtn}" Tag="QR"/>
                <Button x:Name="TabISE" Content="🔒  ISE NAC"
                        Style="{StaticResource TabBtn}" Tag="ISE"/>
            </StackPanel>
        </Border>

        <Grid Grid.Row="2">

            <Grid x:Name="PageServers" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="50"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <StackPanel Grid.Row="0" Orientation="Horizontal"
                            HorizontalAlignment="Center" VerticalAlignment="Center">
                    <Button x:Name="SrvTabBase" Content="⚡ BASE"
                            Style="{StaticResource SrvTabBtnActive}" Tag="BASE" Margin="4,0"/>
                    <Button x:Name="SrvTabImport" Content="📥 IMPORT"
                            Style="{StaticResource SrvTabBtn}" Tag="IMPORT" Margin="4,0"/>
                    <Button x:Name="SrvTabPrint" Content="🖨 PRINT"
                            Style="{StaticResource SrvTabBtn}" Tag="PRINT" Margin="4,0"/>
                    <Button x:Name="SrvTabArchive" Content="📦 ARCHIVE"
                            Style="{StaticResource SrvTabBtn}" Tag="ARCHIVE" Margin="4,0"/>
                </StackPanel>
                <UniformGrid Grid.Row="1" Columns="3" Margin="30,10,30,20">
                    <Border Background="#131920" CornerRadius="10" Margin="8" Padding="0,0,0,10">
                        <StackPanel>
                            <Border Background="#1A2333" CornerRadius="8,8,0,0" Padding="16,12">
                                <TextBlock Foreground="White" FontSize="15" FontWeight="Bold">
                                    <Run Text="📍 "/><Run Text="LTN1"/>
                                </TextBlock>
                            </Border>
                            <StackPanel Margin="12,8">
                                <Button Content="BZ  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN1|BZ"/>
                                <Button Content="MB  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN1|MB"/>
                                <Button Content="MLB  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN1|MLB"/>
                                <Button Content="PORSCHE + LAMBO  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN1|PORSCHE"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                    <Border Background="#131920" CornerRadius="10" Margin="8" Padding="0,0,0,10">
                        <StackPanel>
                            <Border Background="#1A2333" CornerRadius="8,8,0,0" Padding="16,12">
                                <TextBlock Foreground="White" FontSize="15" FontWeight="Bold">
                                    <Run Text="📍 "/><Run Text="LTN2"/>
                                </TextBlock>
                            </Border>
                            <StackPanel Margin="12,8">
                                <Button Content="HV  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN2|HV"/>
                                <Button Content="V2L  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN2|V2L"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                    <Border Background="#131920" CornerRadius="10" Margin="8" Padding="0,0,0,10">
                        <StackPanel>
                            <Border Background="#1A2333" CornerRadius="8,8,0,0" Padding="16,12">
                                <TextBlock Foreground="White" FontSize="15" FontWeight="Bold">
                                    <Run Text="📍 "/><Run Text="LTN4"/>
                                </TextBlock>
                            </Border>
                            <StackPanel Margin="12,8">
                                <Button Content="G2X  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN4|G2X"/>
                                <Button Content="K8X  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN4|K8X"/>
                                <Button Content="SZ  →" Style="{StaticResource BtnServer}" Margin="0,4" Tag="LTN4|SZ"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                </UniformGrid>
            </Grid>

            <Grid x:Name="PageLeps" Visibility="Collapsed">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel MaxWidth="520" HorizontalAlignment="Center" Margin="0,20">
                        <Border Background="#131920" CornerRadius="10" Padding="20" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,12">
                                    <Run Text="🚀 "/><Run Text="INSTALLATION"/>
                                </TextBlock>
                                <Button Content="📁  Open Installation Folder" Style="{StaticResource BtnBlue}"/>
                                <Button Content="🚀  Auto Install (Select Programs)" Style="{StaticResource BtnGreen}"/>
                                <Button Content="⚡  Auto Install (PMS + Auto Login + Startup)" Style="{StaticResource BtnBlue}"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#131920" CornerRadius="10" Padding="20" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,12">
                                    <Run Text="⚙ "/><Run Text="CONFIGURATION"/>
                                </TextBlock>
                                <Button Content="📋  Requete (In Process + Idle)" Style="{StaticResource BtnDark}"/>
                                <Button Content="💬  Configuration Requete" Style="{StaticResource BtnDark}"/>
                                <Button Content="▶  START LEPS (Select Server)" Style="{StaticResource BtnBlue}"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#131920" CornerRadius="10" Padding="20">
                            <StackPanel>
                                <TextBlock Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,12">
                                    <Run Text="🚀 "/><Run Text="STARTUP"/>
                                </TextBlock>
                                <Button Content="📁  Open Startup Folder" Style="{StaticResource BtnDark}"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>
            </Grid>

            <Grid x:Name="PageApps" Visibility="Collapsed">
                <Border Background="#131920" CornerRadius="10" MaxWidth="420" MaxHeight="200"
                        HorizontalAlignment="Center" VerticalAlignment="Center" Padding="24">
                    <StackPanel>
                        <TextBlock Text="APPLICATIONS" Foreground="White"
                                   FontSize="15" FontWeight="Bold" Margin="0,0,0,16"/>
                        <Button Content="🖥  IT Administration" Style="{StaticResource BtnBlue}"/>
                        <Button Content="🖨  LEPS Printing Administration" Style="{StaticResource BtnDark}"/>
                    </StackPanel>
                </Border>
            </Grid>

            <Grid x:Name="PageQR" Visibility="Collapsed">
                <Border Background="#131920" CornerRadius="10" MaxWidth="500" MaxHeight="420"
                        HorizontalAlignment="Center" VerticalAlignment="Center" Padding="24">
                    <StackPanel>
                        <TextBlock Text="QR Code Generator" Foreground="White"
                                   FontSize="16" FontWeight="Bold" Margin="0,0,0,4"/>
                        <TextBlock Text="Text Content" Foreground="#8B9BB4" FontSize="12" Margin="0,0,0,6"/>
                        <TextBox x:Name="txtQRContent" Height="90" TextWrapping="Wrap"
                                 AcceptsReturn="True" VerticalScrollBarVisibility="Auto" Margin="0,0,0,12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,12">
                            <Button Content="📷  Generate QR" Style="{StaticResource BtnBlue}"
                                    Width="160" Margin="0,0,8,0"/>
                            <Button Content="📋  Copy QR Image" Style="{StaticResource BtnDark}"
                                    Width="150" Margin="0,0,8,0"/>
                            <Button Content="💾  Save as PNG" Style="{StaticResource BtnGreen}" Width="140"/>
                        </StackPanel>
                        <Border Background="#0D1117" CornerRadius="6" Height="160">
                            <Image x:Name="imgQR" Stretch="Uniform" Margin="10"/>
                        </Border>
                    </StackPanel>
                </Border>
            </Grid>

            <Grid x:Name="PageISE" Visibility="Collapsed">
                <Border Background="#131920" CornerRadius="10" MaxWidth="380" MaxHeight="220"
                        HorizontalAlignment="Center" VerticalAlignment="Center" Padding="30">
                    <StackPanel>
                        <TextBlock Text="Cisco ISE NAC" Foreground="White"
                                   FontSize="18" FontWeight="Bold" Margin="0,0,0,4"/>
                        <TextBlock Text="Network Access Control Administration"
                                   Foreground="#8B9BB4" FontSize="12" Margin="0,0,0,20"/>
                        <Button Content="🌐  Open ISE NAC Portal" Style="{StaticResource BtnBlue}"/>
                    </StackPanel>
                </Border>
            </Grid>

        </Grid>

        <Border Grid.Row="3" Background="#0A0F16" BorderBrush="#1E2530" BorderThickness="0,1,0,0">
            <Grid Margin="16,0">
                <TextBlock x:Name="txtStatus" Text="Found 9 server(s) · Action: BASE"
                           Foreground="#8B9BB4" FontSize="11"
                           VerticalAlignment="Center" HorizontalAlignment="Left"/>
                <TextBlock Foreground="#3B7BF5" FontSize="11"
                           VerticalAlignment="Center" HorizontalAlignment="Right">
                    <Run Text="v1.0"/>
                    <Run Text="  "/>
                    <Run Text="IT Department"/>
                </TextBlock>
            </Grid>
        </Border>
    </Grid>
</Window>
"@
