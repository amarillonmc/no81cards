--源于黑影 空壳
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(s.sprcon)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCost(s.descost)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(s.tnop)
	c:RegisterEffect(e6)
end

s.effect_lixiaoguo=true

function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetHandler():GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(s.descon1)
	e2:SetOperation(s.desop1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end


function s.sprfilter(c,sc)  
	local tp=sc:GetControler()
	return 
	(
		(
		c:IsLocation(LOCATION_SZONE) 
		and 
			(
				(
				Duel.GetFlagEffect(tp,65820099)==0 and sc:GetFlagEffect(65820010)==0 
				)
			or 
				(
				Duel.GetFlagEffect(tp,65820099)>0 and sc:GetFlagEffect(65820010)>0
				)
			)
		)
		or 
		(
			c:IsLocation(LOCATION_EXTRA) and c:IsCanBeXyzMaterial(sc)
			and 
			(
				(
				Duel.GetFlagEffect(tp,65820099)>0 and sc:GetFlagEffect(65820010)==0 
				)
			or 
				(
				Duel.GetFlagEffect(tp,65820099)==0 and sc:GetFlagEffect(65820010)>0
				)
			) 
		or 
			(
			c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsCanBeXyzMaterial(sc)
			)
		)
	)
	and 
	c:IsSetCard(0x3a32) and not c:IsCode(id)
end 
function s.spgckfil(g,e,tp,sc) 
	return Duel.GetLocationCountFromEx(tp,tp,g,nil)
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,c,c)
	return g:CheckSubGroup(s.spgckfil,2,2,e,tp)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c) 
	local c=e:GetHandler()
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,c,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:SelectSubGroup(tp,s.spgckfil,true,2,2,e,tp)
	if g1:IsExists(Card.IsLocation,1,c,LOCATION_EXTRA) then
		for i=0,10 do
			Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
		end
		local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
		Duel.ResetFlagEffect(tp,65820099)
		for i=1,count do
			Duel.RegisterFlagEffect(tp,65820099,0,0,1)
		end
		local te=Effect.CreateEffect(e:GetHandler())
		te:SetDescription(aux.Stringid(65820000,count))
		te:SetType(EFFECT_TYPE_FIELD)
		te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
		te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		te:SetTargetRange(1,0)
		Duel.RegisterEffect(te,tp)
	end
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1) 
	Duel.Overlay(c,g1)
end





function s.filter(c)
	return c:IsAbleToDeckOrExtraAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup():Filter(s.filter,nil)
	if chk==0 then return #mg>0 or Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,0,#mg+1,nil)
	Duel.HintSelection(g)
	local g1=g+mg
	if g1 then
		e:SetLabel(g1:GetCount())
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabel() then return end
	local count=e:GetLabel()*1000
	Duel.SetLP(tp,Duel.GetLP(tp)-count)
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
	end
end



