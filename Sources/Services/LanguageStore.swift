//
//  LanguageStore.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation
import Combine

public final class LanguageStore: ObservableObject {
    public static let shared = LanguageStore()
    
    private let defaultsKey = "ffxc.langSelected"
    
    @Published public var current: FFLanguage {
        didSet {
            UserDefaults.standard.set(current.rawValue, forKey: defaultsKey)
        }
    }
    
    public init() {
        if let saved = UserDefaults.standard.string(forKey: "ffxc.langSelected"),
           let lang = FFLanguage(rawValue: saved) {
            self.current = lang
        } else {
            self.current = .english
        }
    }
    
    public func setLanguage(_ language: FFLanguage) {
        self.current = language
    }
    
    // Localized string dictionary matching dumped IPA strings
    public func text(_ key: String) -> String {
        switch current {
        case .english:
            return englishDict[key] ?? key
        case .indonesian:
            return indonesianDict[key] ?? englishDict[key] ?? key
        case .vietnamese:
            return vietnameseDict[key] ?? englishDict[key] ?? key
        case .portuguese:
            return portugueseDict[key] ?? englishDict[key] ?? key
        case .moroccan:
            return moroccanDict[key] ?? arabicDict[key] ?? englishDict[key] ?? key
        case .arabic:
            return arabicDict[key] ?? englishDict[key] ?? key
        case .taiwanese:
            return taiwaneseDict[key] ?? englishDict[key] ?? key
        }
    }
    
    private let englishDict: [String: String] = [
        "app_title": "FFXC / PRIVATE EDITION",
        "key_placeholder": "ENTER LICENSE KEY",
        "verify_key": "VERIFY LICENSE",
        "validating": "Verifying...",
        "status_online": "STATUS : ONLINE",
        "status_offline": "STATUS : OFFLINE",
        "status_ready": "READY",
        "status_injecting": "INJECTING...",
        "inject_button": "INJECT",
        "reset_button": "RESET",
        "logout_confirm_title": "Logout",
        "logout_confirm_msg": "You will need to enter your key again.",
        "logout_confirm_yes": "Yes, Logout",
        "logout_confirm_cancel": "Cancel",
        "inject_success": "Injection complete. Launching game.",
        "inject_failed": "Injection failed.",
        "game_not_installed": "The selected game is not installed",
        "container_unavailable": "Game container not found - tap Inject to retry",
        "container_bridge_unavailable": "Private container access is unavailable in this installation environment",
        "invalid_key": "Invalid or expired key",
        "select_language": "Select Language",
        "free_fire": "Free Fire",
        "free_fire_max": "Free Fire MAX",
        "radius_label": "FOV Radius",
        "headshot_label": "Headshot Rate",
        "target_label": "Aim Target",
        "telegram_link": "Join Telegram"
    ]
    
    private let indonesianDict: [String: String] = [
        "app_title": "FFXC / EDISI PRIBADI",
        "key_placeholder": "MASUKKAN KUNCI LISENSI",
        "verify_key": "VERIFIKASI KUNCI",
        "validating": "Memeriksa...",
        "status_online": "STATUS : ONLINE",
        "status_offline": "STATUS : OFFLINE",
        "status_ready": "SIAP",
        "status_injecting": "MENYUNTIK...",
        "inject_button": "INJEKSI",
        "reset_button": "RESET",
        "logout_confirm_title": "Keluar",
        "logout_confirm_msg": "Anda perlu memasukkan kunci lagi.",
        "logout_confirm_yes": "Ya, Keluar",
        "logout_confirm_cancel": "Batal",
        "inject_success": "Injeksi selesai. Membuka game.",
        "inject_failed": "Injeksi gagal.",
        "game_not_installed": "Game yang dipilih belum terinstal",
        "container_unavailable": "Kontainer game tidak ditemukan - ketuk Injeksi untuk mencoba lagi",
        "container_bridge_unavailable": "Akses kontainer privat tidak tersedia di lingkungan ini",
        "invalid_key": "Kunci tidak valid atau sudah kedaluwarsa",
        "select_language": "Pilih Bahasa",
        "free_fire": "Free Fire",
        "free_fire_max": "Free Fire MAX",
        "radius_label": "Radius FOV",
        "headshot_label": "Tingkat Headshot",
        "target_label": "Target Bidikan",
        "telegram_link": "Gabung Telegram"
    ]
    
    private let vietnameseDict: [String: String] = [
        "app_title": "FFXC / PHIÊN BẢN RIÊNG",
        "key_placeholder": "NHẬP MÃ KHÓA",
        "verify_key": "XÁC NHẬN MÃ",
        "validating": "Đang xác nhận...",
        "status_online": "TRẠNG THÁI : ONLINE",
        "status_offline": "TRẠNG THÁI : OFFLINE",
        "status_ready": "SẴN SÀNG",
        "status_injecting": "ĐANG TIÊM...",
        "inject_button": "TIÊM",
        "reset_button": "ĐẶT LẠI",
        "logout_confirm_title": "Đăng xuất",
        "logout_confirm_msg": "Bạn sẽ cần nhập lại khóa của mình.",
        "logout_confirm_yes": "Đăng xuất",
        "logout_confirm_cancel": "Hủy",
        "inject_success": "Tiêm xong. Đang khởi động game.",
        "inject_failed": "Tiêm thất bại.",
        "game_not_installed": "Trò chơi đã chọn chưa được cài đặt",
        "container_unavailable": "Không tìm thấy container trò chơi - nhấn Tiêm để thử lại",
        "container_bridge_unavailable": "Môi trường hiện tại không cấp quyền truy cập container",
        "invalid_key": "Khóa không hợp lệ hoặc đã hết hạn",
        "select_language": "Chọn ngôn ngữ",
        "free_fire": "Free Fire",
        "free_fire_max": "Free Fire MAX",
        "radius_label": "Bán kính FOV",
        "headshot_label": "Tỷ lệ Headshot",
        "target_label": "Mục tiêu ngắm",
        "telegram_link": "Tham gia Telegram"
    ]
    
    private let portugueseDict: [String: String] = [
        "app_title": "FFXC / EDIÇÃO PRIVADA",
        "key_placeholder": "DIGITE A CHAVE",
        "verify_key": "VERIFICAR CHAVE",
        "validating": "Verificando...",
        "status_online": "STATUS : ONLINE",
        "status_offline": "STATUS : OFFLINE",
        "status_ready": "PRONTO",
        "status_injecting": "INJETANDO...",
        "inject_button": "INJETAR",
        "reset_button": "RESETAR",
        "logout_confirm_title": "Sair",
        "logout_confirm_msg": "Você precisará inserir sua chave novamente.",
        "logout_confirm_yes": "Sim, Sair",
        "logout_confirm_cancel": "Cancelar",
        "inject_success": "Injeção completa. Iniciando jogo.",
        "inject_failed": "Falha na injeção.",
        "game_not_installed": "O jogo selecionado não está instalado",
        "container_unavailable": "Container do jogo não encontrado - toque em Injetar para tentar novamente",
        "container_bridge_unavailable": "Acesso ao container privado indisponível neste ambiente",
        "invalid_key": "Chave inválida ou expirada",
        "select_language": "Selecionar idioma",
        "free_fire": "Free Fire",
        "free_fire_max": "Free Fire MAX",
        "radius_label": "Raio do FOV",
        "headshot_label": "Taxa de Headshot",
        "target_label": "Alvo da Mira",
        "telegram_link": "Entrar no Telegram"
    ]
    
    private let moroccanDict: [String: String] = [
        "app_title": "FFXC / طبعة خاصة",
        "key_placeholder": "دخل الساروت ديالك",
        "verify_key": "تحقق من الساروت",
        "validating": "جاري التحقق...",
        "status_online": "الحالة : متصل",
        "status_offline": "الحالة : غير متصل",
        "status_ready": "واجد",
        "status_injecting": "جاري الحقن...",
        "inject_button": "حقن",
        "reset_button": "إعادة ضبط",
        "logout_confirm_title": "تسجيل الخروج",
        "logout_confirm_msg": "خاصك تعاود دخل الساروت ديالك.",
        "logout_confirm_yes": "خروج",
        "logout_confirm_cancel": "إلغاء",
        "inject_success": "اكتمل الحقن. جاري تشغيل اللعبة.",
        "inject_failed": "فشل الحقن.",
        "game_not_installed": "اللعبة المختارة مامثبتش فالهاتف",
        "container_unavailable": "ما لقيناش ملفات اللعبة - عاود ضغط على حقن",
        "container_bridge_unavailable": "ولوج ملفات التطبيقات غير متاح فهاد البيئة",
        "invalid_key": "الساروت غير صالح أو مسالي",
        "select_language": "اختار اللغة",
        "free_fire": "فري فاير",
        "free_fire_max": "فري فاير MAX",
        "radius_label": "نطاق FOV",
        "headshot_label": "نسبة الهيدشوت",
        "target_label": "الهدف",
        "telegram_link": "مجموعة تيليغرام"
    ]
    
    private let arabicDict: [String: String] = [
        "app_title": "FFXC / النسخة الخاصة",
        "key_placeholder": "أدخل مفتاح الترخيص",
        "verify_key": "التحقق من المفتاح",
        "validating": "جاري التحقق...",
        "status_online": "الحالة : متصل",
        "status_offline": "الحالة : غير متصل",
        "status_ready": "جاهز",
        "status_injecting": "جاري الحقن...",
        "inject_button": "حقن",
        "reset_button": "إعادة تعيين",
        "logout_confirm_title": "تسجيل الخروج",
        "logout_confirm_msg": "ستحتاج إلى إدخال المفتاح مرة أخرى.",
        "logout_confirm_yes": "نعم، خروج",
        "logout_confirm_cancel": "إلغاء",
        "inject_success": "اكتمل الحقن. جاري تشغيل اللعبة.",
        "inject_failed": "فشل الحقن.",
        "game_not_installed": "اللعبة المحددة غير مثبتة على الجهاز",
        "container_unavailable": "لم يتم العثور على حاوية اللعبة - اضغط حقن للمحاولة مرة أخرى",
        "container_bridge_unavailable": "الوصول إلى حاويات التطبيقات الخاصة غير مدعوم",
        "invalid_key": "المفتاح غير صالح أو منتهي الصلاحية",
        "select_language": "اختر اللغة",
        "free_fire": "فري فاير",
        "free_fire_max": "فري فاير MAX",
        "radius_label": "نطاق زاوية الرؤية",
        "headshot_label": "معدل الرأس (Headshot)",
        "target_label": "الهدف المستهدف",
        "telegram_link": "انضم إلى تيليجرام"
    ]
    
    private let taiwaneseDict: [String: String] = [
        "app_title": "FFXC / 私人尊享版",
        "key_placeholder": "請輸入卡密金鑰",
        "verify_key": "驗證金鑰",
        "validating": "正在驗證...",
        "status_online": "狀態：ONLINE",
        "status_offline": "狀態：OFFLINE",
        "status_ready": "就緒",
        "status_injecting": "正在注入...",
        "inject_button": "立即注入",
        "reset_button": "重置設定",
        "logout_confirm_title": "登出確認",
        "logout_confirm_msg": "您需要重新輸入金鑰。",
        "logout_confirm_yes": "確認登出",
        "logout_confirm_cancel": "取消",
        "inject_success": "注入完成。正在啟動遊戲。",
        "inject_failed": "注入失敗。",
        "game_not_installed": "尚未安裝所選遊戲",
        "container_unavailable": "未找到遊戲容器 - 請點擊注入重試",
        "container_bridge_unavailable": "此安裝環境無法訪問私有容器",
        "invalid_key": "密鑰無效或已過期",
        "select_language": "選擇語言",
        "free_fire": "Free Fire",
        "free_fire_max": "Free Fire MAX",
        "radius_label": "視野半徑 (FOV)",
        "headshot_label": "爆頭機率",
        "target_label": "自瞄部位",
        "telegram_link": "加入 Telegram 頻道"
    ]
}
