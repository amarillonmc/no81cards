--螺旋之妖精 传说中的切尔莉
function c60150798.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
end
c60150798.is_named_with_Ma_Elf=1
function c60150798.IsMa_Elf(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Ma_Elf 
end
