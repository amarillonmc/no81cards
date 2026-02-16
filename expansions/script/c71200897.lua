--绝音魔女的邪之契约
function c71200897.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	c:RegisterEffect(e1) 
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80604091,1))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71200897)
	e1:SetCondition(c71200897.smcon) 
	e1:SetTarget(c71200897.smtg)
	e1:SetOperation(c71200897.smop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80604091,2)) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,71200898) 
	e2:SetTarget(c71200897.settg)
	e2:SetOperation(c71200897.setop)
	c:RegisterEffect(e2)
end
function c71200897.smcon(e,tp,eg,ep,ev,re,r,rp) 
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)  
end 
function c71200897.smfilter(c)
	return (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)) and c:IsSetCard(0x895)
end
function c71200897.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct1=Duel.GetMatchingGroupCount(c71200897.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local ct2=Duel.GetFlagEffect(tp,80604091)
		return ct1-ct2>0
	end
	Duel.RegisterFlagEffect(tp,80604091,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c71200897.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c71200897.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function c71200897.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not (c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL))   
end 
function c71200897.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then Duel.IsExistingTarget(c71200897.setfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c71200897.setfil,tp,LOCATION_GRAVE,0,1,1,nil) 
end
function c71200897.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SSet(tp,tc) 
	end 
end 





