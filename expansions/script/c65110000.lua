--浮游城
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(s.cost)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.fcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	--add type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetCondition(s.fcon)
	e3:SetValue(TYPE_XYZ)
	c:RegisterEffect(e3)
	--overlay
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(s.ovop)
	c:RegisterEffect(e4)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(s.fcon)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(1,0)
	e8:SetCondition(s.fcon)
	e8:SetTarget(s.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(1,0)
	e9:SetCondition(s.fcon)
	e9:SetValue(s.actlimit)
	c:RegisterEffect(e9)
	if not s.global_check then
		s.global_check=true
		_Overlay=Duel.Overlay
		function Duel.Overlay(c,ocard)
			local e=Effect.CreateEffect(c)
			Duel.RaiseEvent(c,EVENT_CUSTOM+id,e,0,0,0,0)
			_Overlay(c,ocard)
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.fcon(e)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	return c:IsLocation(LOCATION_SZONE) and seq==5 or (seq==6 and (not KOISHI_CHECK or Duel.GetMasterRule()>=4))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:GetCount()==1 and eg:GetFirst()==c and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e)
	e1:SetCondition(s.spccon)
	e1:SetOperation(s.spcop)
	Duel.RegisterEffect(e1,tp)
end
function s.spccon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e:GetLabelObject()
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject():GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if c:IsOnField()  then
		local og=c:GetOverlayGroup()
		g:Merge(og)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local g=c:GetOverlayGroup()
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,3))
	g:Select(p,0,1,nil)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.SendtoDeck(og,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_FZONE) then Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
	if not KOISHI_CHECK or Duel.GetMasterRule()>=4 then Duel.MoveSequence(c,6) end
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.fcon)
	e1:SetOperation(s.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then Duel.SendtoGrave(c,REASON_RULE) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(id,2))
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end