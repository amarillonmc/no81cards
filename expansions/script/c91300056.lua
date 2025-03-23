--积尸气魔 阿帕奥沙
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,99,s.lcheck)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCondition(Auxiliary.LinkCondition(aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2,s.lcheck))
	e0:SetTarget(Auxiliary.LinkTarget(aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2,s.lcheck))
	e0:SetOperation(Auxiliary.LinkOperation(aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2,s.lcheck))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
end
s.Findesiecle=true
function s.matfilter(c)
	return _G["c"..c:GetCode()] and _G["c"..c:GetCode()].Findesiecle
end
function s.lcheck(g,lc)
	return g:IsExists(s.matfilter,1,nil)
end
function s.lkfilter(c)
	return c:IsLinkSummonable(nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.mattg)
	e1:SetValue(s.matval)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_LINK_RACE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(RACE_ZOMBIE)
	Duel.RegisterEffect(e2,tp)
	return e1
end
function s.mattg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.matval(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,true
end
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=s.regop(e,tp)
		local res=Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=s.regop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SPSUMMON_COST)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetLabelObject(e1)
		e3:SetOperation(s.resetop)
		tc:RegisterEffect(e3)
		Duel.LinkSummon(tp,tc,nil)
	else
		e1:Reset()
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function s.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_GRAVE,1,nil) and e:GetHandler():IsAbleToExtra() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsLinkSummonable(nil) end
	Duel.SetTargetCard(e:GetHandler())
	--e:SetLabelObject(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.NegateActivation(ev) then
		if e:GetHandler():IsRelateToChain() and e:GetHandler():IsLocation(LOCATION_EXTRA) then
			Duel.LinkSummon(tp,e:GetHandler(),nil)
		end
	end
end