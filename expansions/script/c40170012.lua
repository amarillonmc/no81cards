--DDD 龙霸王 终结潘德拉刚
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,4)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)   
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2) 
end
function s.getlrl(c)
	if c:IsLevelAbove(1) then
		return c:GetLevel()
	elseif c:IsRankAbove(1) then
		return c:GetRank()
	elseif c:IsLinkAbove(1) then
		return c:GetLink()
	end
	return NULL_VALUE 
end
function s.GetScale(c)
	if not c:IsType(TYPE_PENDULUM) then return NULL_VALUE end
	local sc=NULL_VALUE
	if c:IsLocation(LOCATION_PZONE) then
		local seq=c:GetSequence()
		if seq==0 
		or seq==6
		then sc=c:GetLeftScale() else sc=c:GetRightScale() end
	else
		sc=c:GetLeftScale()
	end
	return sc
end
function s.GetScaleDiff(g)
	if not #g==2 then return NULL_VALUE end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1 and tc2 then
		local sc1,sc2=s.GetScale(tc1),s.GetScale(tc2)
		return math.abs(sc1-sc2)
	end
	return NULL_VALUE
end
function s.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thselect(g,diff)
	return g and s.GetScaleDiff(g)<=diff
end
function s.cfilter(c,tp)
	local diff=s.getlrl(c)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
	return c:IsFaceup() and diff>0 and g:CheckSubGroup(s.thselect,2,2,diff)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local diff=s.getlrl(tc)
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
		if Duel.Destroy(tc,REASON_EFFECT)>0 and diff>0 and g:CheckSubGroup(s.thselect,2,2,diff) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=g:SelectSubGroup(tp,s.thselect,false,2,2,diff)
			if #tg==2 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end
function s.val(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),LOCATION_PZONE,0)
	return g:GetSum(s.GetScale)*100
end