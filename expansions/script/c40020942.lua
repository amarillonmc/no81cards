local s,id=GetID()
s.named_with_Galaxian=1

function s.Galaxian(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Galaxian
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,s.matfilter,2,2)
	
	aux.AddContactFusionProcedure(c,
		aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),
		LOCATION_MZONE,0,
		Duel.Release,
		REASON_SPSUMMON+REASON_MATERIAL
	)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg1)
	e1:SetOperation(s.desop1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.desop2)
	c:RegisterEffect(e2)
end

function s.matfilter(c,fc,sumtype,tp)
	return s.Galaxian(c)
end

function s.gfilter(c)
	if c:IsLocation(LOCATION_MZONE) then
		return s.Galaxian(c) and c:IsFaceup()
	else
		return s.Galaxian(c)
	end
end

function s.countGalaxian(tp,c)
	local g=Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	local codes={}
	local count=0
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetCode()
		if not codes[code] then
			codes[code]=true
			count=count+1
		end
		tc=g:GetNext()
	end
	return count
end

function s.desfilter1(c,maxatk)
	return c:IsFaceup() and c:GetAttack()<=maxatk
end

function s.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local count=s.countGalaxian(tp,c)
	local maxatk=3000+count*1000
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter1,tp,0,LOCATION_MZONE,1,nil,maxatk) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end

function s.atkfilter1(c,sg,totalatk,maxatk)
	return not sg:IsContains(c) and c:IsFaceup() and (totalatk+c:GetAttack())<=maxatk
end

function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=s.countGalaxian(tp,c)
	local maxatk=3000+count*1000
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	local sg=Group.CreateGroup()
	local totalatk=0
	local first=true
	while true do
		local tg=g:Filter(s.atkfilter1,nil,sg,totalatk,maxatk)
		if #tg==0 then break end
		if not first then
			if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				break
			end
		end
		first=false
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)
		totalatk=totalatk+tc:GetAttack()
	end
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function s.gfilter2(c)
	return c:IsFaceup() and s.Galaxian(c)
end

function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.gfilter2,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
end

function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.gfilter2,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if #g==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,math.min(ct,#g),nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end