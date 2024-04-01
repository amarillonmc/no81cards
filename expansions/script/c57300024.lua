--流界女·燃毁
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3520),5,63,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id+o*100)
	e2:SetCost(s.cost)
	e2:SetTarget(s.rmtg2)
	e2:SetOperation(s.rmop2)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0x3520) then
		Duel.RegisterFlagEffect(re:GetHandlerPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x3520) or not re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.raclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_REMOVED) and not re:GetHandler():IsSetCard(0x3520)
end
function s.raclimit(e,c,rp,r,re)
	return r&REASON_EFFECT~=0 and not re:GetHandler():IsSetCard(0x3520)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.chkfilter(c)
	return not c:IsAbleToRemove()
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
			and not Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local rg=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if rg:GetCount()>0 then
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RETURN)
	end
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=false
	for i=0,5 do
		local tg=nil
		if i~=0 then
			tg=Duel.GetDecktopGroup(tp,i)
		end
		local dg=nil
		if i~=5 then
			dg=Duel.GetDecktopGroup(1-tp,5-i)
		end
		if not tg or tg and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEUP)==i then
			if not dg or dg and dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEUP)==5-i then
				if not res then
					res=true
				end
			end
		end
	end
	if chk==0 then return res end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,2,LOCATION_DECK)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local rt={}
	for i=0,5 do
		local tg=nil
		if i~=0 then
			tg=Duel.GetDecktopGroup(tp,i)
		end
		local dg=nil
		if i~=5 then
			dg=Duel.GetDecktopGroup(1-tp,5-i)
		end
		if not tg or tg and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEUP)==i then
			if not dg or dg and dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEUP)==5-i then
				rt[i]=i
				if not res then
					res=true
				end
			end
		end
	end
	local pc=0
	for i=0,5 do
		if rt[i] then rt[i]=nil rt[pc]=i pc=pc+1 end
	end
	rt[pc]=nil
	if res then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local r=Duel.AnnounceNumber(tp,table.unpack(rt))
		local tg=Duel.GetDecktopGroup(tp,r)
		if #tg~=0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
		local dr=5-r
		local dg=Duel.GetDecktopGroup(1-tp,dr)
		if #dg~=0 then
			Duel.DisableShuffleCheck()
			if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)<0 then
				local g=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				for tc in aux.Next(g) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1,true)
				end
			end
		end
	end
end