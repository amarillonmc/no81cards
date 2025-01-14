--秘计螺旋 偏差
local s,id,o=GetID()
function s.initial_effect(c)
	c:RegisterFlagEffect(id,0,0,0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local _GetType=Card.GetType
		function Card.GetType(c)
			local re=c:IsHasEffect(id)
			if re then return re:GetLabel() end
			return _GetType(c)
		end
		local _IsType=Card.IsType
		function Card.IsType(c,ctype)
			return Card.GetType(c)&ctype>0
		end
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_SSET)
		ge0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge0:SetCondition(s.setcon)
		ge0:SetOperation(s.setop)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		ge1:SetCode(EVENT_CUSTOM+65131100)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.setfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==0 or c:GetSequence()==4)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(s.setfilter,1,nil)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.setfilter,nil)
	for tc in aux.Next(g) do
		Duel.ConfirmCards(1-tp,tc)
		tc:SetCardData(CARDDATA_LSCALE,4)
		tc:SetCardData(CARDDATA_RSCALE,4)
		local e0=Effect.CreateEffect(tc)
		e0:SetCode(id)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e0:SetLabel(tc:GetType())
		tc:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_MONSTER+TYPE_PENDULUM)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END,4)
		e2:SetOperation(s.hintop)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetLabelObject(e2)
		e3:SetOperation(s.leaveop)
		tc:RegisterEffect(e3,true)
		s[tc]=e2
		tc:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,4)
	end
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(1082946)
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.hintop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(id) and c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
		if c:GetSequence()==0 and Duel.ReadCard(c,CARDDATA_LSCALE)>0 then
			c:SetCardData(CARDDATA_LSCALE,Duel.ReadCard(c,CARDDATA_LSCALE)-1)
		end
		if c:GetSequence()==4 and Duel.ReadCard(c,CARDDATA_RSCALE)>0 then
			c:SetCardData(CARDDATA_RSCALE,Duel.ReadCard(c,CARDDATA_RSCALE)-1)
		end
	end
	if Duel.ReadCard(c,CARDDATA_LSCALE)==0 or Duel.ReadCard(c,CARDDATA_RSCALE)==0 then
		c:ResetFlagEffect(1082946)
		e:Reset()
	end
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local sc=100
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence()==0 then sc=Duel.ReadCard(c,CARDDATA_LSCALE) end
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence()==4 then sc=Duel.ReadCard(c,CARDDATA_RSCALE) end
	if chk==0 then return sc==0 or sc~=100 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=sc and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,sc,nil) end
	if sc==0 then return end
	local sg=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,sc,sc,nil)
	Duel.SSet(tp,sg,tp,false)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:GetFlagEffect(id)>0 and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsSSetable())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not tc:IsSSetable() or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)==0)) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		Duel.SSet(tp,tc)
	end
end