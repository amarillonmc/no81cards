--源于黑影 支配
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	c:SetSPSummonOnce(id)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	e3=e2:Clone()
	e3:SetCondition(s.sprcon1)
	e3:SetOperation(s.sprop1)
	c:RegisterEffect(e3)
	e4=e2:Clone()
	e4:SetCondition(s.sprcon2)
	e4:SetOperation(s.sprop2)
	c:RegisterEffect(e4)
	e5=e2:Clone()
	e5:SetCondition(s.sprcon3)
	e5:SetOperation(s.sprop3)
	c:RegisterEffect(e5)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
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


function s.thfilter(c,sc)
	return (c:IsCanBeXyzMaterial(sc) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsSetCard(0x3a32) and c:IsFaceupEx()
end
--正面【表】
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)==0 
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local ag=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,s.thfilter,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	Duel.ShuffleHand(tp)
end
--正面【里】
function s.sprcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)==0 
end
function s.sprop1(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	
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
	
	local ag=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,s.thfilter,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
--反面【表】
function s.sprcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and Duel.GetFlagEffect(tp,65820099)==0 and c:GetFlagEffect(65820010)>0 
end
function s.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	local ag=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,s.thfilter,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
--反面【里】
function s.sprcon3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0 and Duel.GetFlagEffect(tp,65820099)>0 and c:GetFlagEffect(65820010)>0 
end
function s.sprop3(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	
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
	
	local ag=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=ag:FilterSelect(tp,s.thfilter,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end



function s.filter(c,sc)
	return c:IsSetCard(0x3a32) and c:IsAbleToHandAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup():Filter(s.filter,nil,tp)
	if chk==0 then return #mg>0 end
	local bc=mg:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoHand(bc,nil,REASON_COST)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-2500)
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_EFFECT,tp,tp,4000)
	end
end