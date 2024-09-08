--终焉数码兽 奥米加兽Alter-S
function c50224115.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetRange(LOCATION_HAND)
	e00:SetCondition(c50224115.spcon)
	e00:SetTarget(c50224115.sptg)
	e00:SetOperation(c50224115.spop)
	c:RegisterEffect(e00)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_SOLVED)
	e11:SetOperation(c50224115.atkop)
	c:RegisterEffect(e11)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c50224115.destg)
	e2:SetOperation(c50224115.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c50224115.thtg)
	e3:SetOperation(c50224115.thop)
	c:RegisterEffect(e3)
end
function c50224115.mfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsCode(50223105,50223110)
end
function c50224115.fselect(g,c,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(Card.GetCode)==2
end
function c50224115.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c50224115.mfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c50224115.fselect,2,2,c,tp)
end
function c50224115.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c50224115.mfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c50224115.fselect,true,2,2,c,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c50224115.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c50224115.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c50224115.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_DESTROY)
	end
end
function c50224115.setfilter(c,e,tp)
	return not (c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK) or c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()) and aux.NecroValleyFilter()(c) 
		and (
			(c:IsType(TYPE_MONSTER) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
			or	
			((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable(true))
			)
end
function c50224115.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup():Filter(c50224115.setfilter,nil,e,tp)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(50224115,0)) then
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			if tc then
				if tc:IsType(TYPE_MONSTER) then
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
					Duel.ConfirmCards(1-tp,tc)
				elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
					Duel.BreakEffect()
					Duel.SSet(tp,tc)
				end
			end
		end
	end
end
function c50224115.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c50224115.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c50224115.thop(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.GetFirstMatchingCard(c50224115.thfilter,tp,LOCATION_REMOVED,0,nil,50223105)
	if not t1 then return end
	local t2=Duel.GetFirstMatchingCard(c50224115.thfilter,tp,LOCATION_REMOVED,0,nil,50223110)
	if not t2 then return end
	local g=Group.FromCards(t1,t2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end