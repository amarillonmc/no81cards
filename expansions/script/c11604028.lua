 --宝可·赤红
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(s.con)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,id+1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end 
function s.thfilter(c,tp)
	local a=c:IsCode(11604025)
	local b=c:IsCode(11604026)
	return ( a and c:IsAbleToHand() ) or ( b and c:GetActivateEffect():IsActivatable(tp,true,true)) 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end		
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if tc:IsCode(11604025) and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,id,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
--
function s.filter(c)
	return c:GetOwner()~=c:GetControler()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function s.filter2(c)
	return c:GetOwner()~=c:GetControler() and ( c:IsAbleToExtra() or c:IsAbleToHand())
end
function s.filter3(c,e,tp)
	return c:GetOwner()~=c:GetControler() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) --and ( (c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp)>0) or（(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) )
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA+CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)  
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()	
		Duel.SendtoHand(tc,tp,REASON_EFFECT,tp)
		if tc:IsLocation(LOCATION_EXTRA+LOCATION_HAND) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
			local sc=sg:GetFirst()  
			Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
		end 
	end
end