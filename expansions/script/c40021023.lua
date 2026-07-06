--空创德尔菲尼
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,s.mfilter1,2,2,s.mcheck)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

function s.mfilter1(c,fc,sub,mg,sg)
	return true 
end

function s.mcheck(g,fc,sumtype,tp)
	local attr=g:GetFirst():GetAttribute()
	if g:IsExists(function(c) return c:GetAttribute()~=attr end,1,nil) then return false end
	local races={}
	for tc in aux.Next(g) do
		local r=tc:GetRace()
		if races[r] then return false end
		races[r]=true
	end
	return true
end

function s.actfilter(c)
	return c:IsFacedown() and s.HighEvo(c) and c:IsType(TYPE_TRAP)
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_SZONE,0,1,nil) end
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ACTIVATE)
	local g=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.ChangePosition(tc,POS_FACEUP)
	local te=tc:GetActivateEffect()
	if te then
		local teg,tep,tev,tre,tr,trp = nil,tp,0,nil,0,tp
		local tg=te:GetTarget()
		if tg then
			tg(te,tp,teg,tep,tev,tre,tr,trp,1)
		end
		local op=te:GetOperation()
		if op then
			tc:CreateEffectRelation(te)
			op(te,tp,teg,tep,tev,tre,tr,trp)
			tc:ReleaseEffectRelation(te)
		end
	end
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_TRAP)
end

function s.setfilter(c,tp)
	return s.HighEvo(c) and c:IsType(TYPE_TRAP) and c:IsSSetable()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 and Duel.SSet(tp,g)>0 then
		local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local des=dg:Select(tp,1,1,nil)
			Duel.Destroy(des,REASON_EFFECT)
		end
	end
end