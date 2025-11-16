--数理地狱·选择题炼狱
function c74610430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_SUMMON)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(aux.NegateSummonCondition)
	e2:SetOperation(c74610430.dsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function c74610430.dsop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetTurnPlayer()
    Duel.Hint(HINT_CARD,p,74610430)
    local num
    repeat
        local d1,d2 = Duel.TossDice(tp,2)
        local x = (d1-1)*6+(d2-1)
        if x < 32 then
            num=x+1
            break
        end
    until false
    local qa=num
    if qa==1 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,2))
        local op = Duel.SelectOption(p,aux.Stringid(74610431,0),aux.Stringid(74610431,1),aux.Stringid(74610431,2))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==2 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,3))
        local op = Duel.SelectOption(p,aux.Stringid(74610431,3),aux.Stringid(74610431,4),aux.Stringid(74610431,5))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==3 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,4))
        local op = Duel.SelectOption(p,aux.Stringid(74610431,6),aux.Stringid(74610431,7),aux.Stringid(74610431,8))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==4 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,5))
        local op = Duel.SelectOption(p,aux.Stringid(74610431,9),aux.Stringid(74610431,10),aux.Stringid(74610431,11))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==5 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,6))
        local op = Duel.SelectOption(p,aux.Stringid(74610431,12),aux.Stringid(74610431,13),aux.Stringid(74610431,14))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==6 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,7))
        local op = Duel.SelectOption(p,aux.Stringid(74610432,0),aux.Stringid(74610432,1),aux.Stringid(74610432,2))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==7 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,8))
        local op = Duel.SelectOption(p,aux.Stringid(74610432,3),aux.Stringid(74610432,4),aux.Stringid(74610432,5))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==8 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,9))
        local op = Duel.SelectOption(p,aux.Stringid(74610432,6),aux.Stringid(74610432,7),aux.Stringid(74610432,8))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==9 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,10))
        local op = Duel.SelectOption(p,aux.Stringid(74610432,9),aux.Stringid(74610432,10),aux.Stringid(74610432,11))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==10 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,11))
        local op = Duel.SelectOption(p,aux.Stringid(74610432,12),aux.Stringid(74610432,13),aux.Stringid(74610432,14))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==11 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,12))
        local op = Duel.SelectOption(p,aux.Stringid(74610433,0),aux.Stringid(74610433,1),aux.Stringid(74610433,2))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==12 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,13))
        local op = Duel.SelectOption(p,aux.Stringid(74610433,3),aux.Stringid(74610433,4),aux.Stringid(74610433,5))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==13 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,14))
        local op = Duel.SelectOption(p,aux.Stringid(74610433,6),aux.Stringid(74610433,7),aux.Stringid(74610433,8))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==14 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610430,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610433,9),aux.Stringid(74610433,10),aux.Stringid(74610433,11))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==15 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610431,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610433,12),aux.Stringid(74610433,13),aux.Stringid(74610433,14))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==16 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610432,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610434,0),aux.Stringid(74610434,1),aux.Stringid(74610434,2))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==17 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610433,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610434,3),aux.Stringid(74610434,4),aux.Stringid(74610434,5))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==18 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610434,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610434,6),aux.Stringid(74610434,7),aux.Stringid(74610434,8))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==19 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610435,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610434,9),aux.Stringid(74610434,10),aux.Stringid(74610434,11))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==20 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610436,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610434,12),aux.Stringid(74610434,13),aux.Stringid(74610434,14))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==21 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610437,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610435,0),aux.Stringid(74610435,1),aux.Stringid(74610435,2))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==22 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,15))
        local op = Duel.SelectOption(p,aux.Stringid(74610435,3),aux.Stringid(74610435,4),aux.Stringid(74610435,5))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==23 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,0))
        local op = Duel.SelectOption(p,aux.Stringid(74610435,6),aux.Stringid(74610435,7),aux.Stringid(74610435,8))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==24 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,1))
        local op = Duel.SelectOption(p,aux.Stringid(74610435,9),aux.Stringid(74610435,10),aux.Stringid(74610435,11))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==25 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,2))
        local op = Duel.SelectOption(p,aux.Stringid(74610435,12),aux.Stringid(74610435,13),aux.Stringid(74610435,14))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==26 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,3))
        local op = Duel.SelectOption(p,aux.Stringid(74610436,0),aux.Stringid(74610436,1),aux.Stringid(74610436,2))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==27 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,4))
        local op = Duel.SelectOption(p,aux.Stringid(74610436,3),aux.Stringid(74610436,4),aux.Stringid(74610436,5))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==28 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,5))
        local op = Duel.SelectOption(p,aux.Stringid(74610436,6),aux.Stringid(74610436,7),aux.Stringid(74610436,8))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==29 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,6))
        local op = Duel.SelectOption(p,aux.Stringid(74610436,9),aux.Stringid(74610436,10),aux.Stringid(74610436,11))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==30 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,7))
        local op = Duel.SelectOption(p,aux.Stringid(74610436,12),aux.Stringid(74610436,13),aux.Stringid(74610436,14))
        if op==2 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==31 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,8))
        local op = Duel.SelectOption(p,aux.Stringid(74610437,0),aux.Stringid(74610437,1),aux.Stringid(74610437,2))
        if op==1 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    elseif qa==32 then
        Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(74610438,9))
        local op = Duel.SelectOption(p,aux.Stringid(74610437,3),aux.Stringid(74610437,4),aux.Stringid(74610437,5))
        if op==0 then
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,0))
            Duel.Draw(p,1,REASON_EFFECT)
        else
            Duel.Hint(HINT_OPSELECTED,p,aux.Stringid(74610430,1))
            Duel.NegateSummon(eg)
            Duel.Destroy(eg,REASON_EFFECT)
        end
    end
end
