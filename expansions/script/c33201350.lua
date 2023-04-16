--六合精工 祥瑞织锦护膊
VHisc_CNTdb=VHisc_CNTdb or {}

function VHisc_CNTdb.the(ec,cid,efcate,efpro)
	local cs=_G["c"..cid]
	--thop
	local e0=Effect.CreateEffect(ec,cid,efcate,efpro)
	e0:SetDescription(aux.Stringid(33201350,1))
	e0:SetCategory(efcate)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(efpro)
	e0:SetCountLimit(1,cid+10000)
	e0:SetCondition(VHisc_CNTdb.thcon)
	e0:SetTarget(cs.thtg)
	e0:SetOperation(cs.thop)
	ec:RegisterEffect(e0)
end
function VHisc_CNTdb.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_GRAVE)
end
function VHisc_CNTdb.spck(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end


-------------code check------------------
function VHisc_CNTdb.nck(c)
	return c.VHisc_CNTreasure or (VHisc_CNTdb.global_check and VHisc_CNTdb.codeck(VHisc_CNTN,c))
end


-------------code table------------------
function VHisc_CNTdb.creattable()
	if not VHisc_CNTdb.global_check then
		VHisc_CNTdb.global_check=true
		VHisc_CNTN={}
		VHisc_CNTN[1]=0 
	end
end
function VHisc_CNTdb.codeck(tab,cc)
	local result=false
	for i,v in ipairs(tab) do
		if cc:GetCode()==v then
			result=true
		end
	end
	return result
end

function VHisc_CNTdb.reset(e,tp,eg,ep,ev,re,r,rp)
	VHisc_CNTN={}
	VHisc_CNTN[1]=0
end


-------------------------card effect------------------------------

local m=33201350
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	VHisc_CNTdb.the(c,m,0x200,0x10000)
	--deckes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.VHisc_CNTreasure=true

--e1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function cm.tgfilter(c)
	return VHisc_CNTdb.nck(c) and c:IsAbleToGrave()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5):Filter(cm.tgfilter,nil)
	g:AddCard(e:GetHandler())
	local tgc=0
	if g:GetCount()>0 then
		tgc=Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
	local desg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if tgc==5 and desg:GetCount()>0 then
		Duel.Destroy(desg,REASON_EFFECT)
	end
end

--e0
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return VHisc_CNTdb.spck(e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--atk up
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetLabel(500)
	e12:SetCountLimit(1)
	e12:SetOperation(cm.turnop)
	Duel.RegisterEffect(e12,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabelObject(e12)
	e1:SetValue(cm.atkval)
	Duel.RegisterEffect(e1,tp)
	e12:SetLabelObject(e1)
end
function cm.atkval(e,c)
	return e:GetLabelObject():GetLabel()
end
function cm.turnop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetLabel()-100)
	if e:GetLabel()<=0 then 
		e:GetLabelObject():Reset()
		e:Reset()
	end
end