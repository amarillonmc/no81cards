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

-------------grave act limit------------------
function VHisc_CNTdb.glm(e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(VHisc_CNTdb.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function VHisc_CNTdb.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
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
	VHisc_CNTdb.the(c,m,0x1+0x200,0x10000)
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
	if tgc>4 and desg:GetCount()>0 then
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
		local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end