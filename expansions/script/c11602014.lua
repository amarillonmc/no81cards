--大海爬兽 猛毒海蛇

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11602000,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),1,true,true)
	
	--cannot select battle target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(s.e1atlimit)
	c:RegisterEffect(e1)
	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.e2tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--DestroyTargetCardAndDefup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)

end

--e1
--cannot select battle target

function s.e1atlimit(e,c)
	return c~=e:GetHandler()
end

--e2
--cannot be target

function s.e2tglimit(e,c)
	return c~=e:GetHandler()
end

--e3
--DestroyTargetCardAndDefup

function s.e3con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    local bl=ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or bl) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.e1tohfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_LINK) then
        local c=e:GetHandler()
        Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,c,1,0,0)
    end
end

function s.e3op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if not sg then return end
	if not Duel.Destroy(sg,REASON_EFFECT) then return end
	
    local tc=sg:GetFirst()
    local c=e:GetHandler()
    if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_LINK) and tc:GetDefense()>0 and c:IsRelateToEffect(e) and not tc:IsLocation(LOCATION_MZONE) then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetDefense())
		c:RegisterEffect(e1)
    end
end