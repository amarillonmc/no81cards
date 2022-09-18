--咒眼之大使徒 沙利叶
local m=30006100
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD)
	e32:SetCode(EFFECT_SPSUMMON_PROC)
	e32:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e32:SetRange(LOCATION_EXTRA)
	e32:SetCondition(cm.spcon)
	e32:SetOperation(cm.spop)
	c:RegisterEffect(e32)
	--adjust
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e33:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e33:SetCode(EVENT_ADJUST)
	e33:SetRange(LOCATION_MZONE)
	e33:SetOperation(cm.adjustop)
	c:RegisterEffect(e33)
	--Effect 1
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(cm.eqtg)
	e4:SetOperation(cm.eqop)
	c:RegisterEffect(e4)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetLabelObject(e1)
	e6:SetCondition(cm.con)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetLabelObject(e1)
	e7:SetCondition(cm.con1)
	e7:SetTarget(cm.tg1)
	e7:SetOperation(cm.op1)
	c:RegisterEffect(e7)
	--Effect 3 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.cytg)
	e2:SetOperation(cm.cyop)
	c:RegisterEffect(e2)
	--Effect 4
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.todeckcon)
	e5:SetTarget(cm.todecktg)
	e5:SetOperation(cm.todeckop)
	c:RegisterEffect(e5) 
end
--special summon rule
function cm.eqspfilter(c)
	return c:IsFaceup() and c:IsCode(44133040)
end
function cm.spfilter(c,sc,tp)
	return c:IsType(TYPE_EFFECT) 
		and c:IsCanBeXyzMaterial(sc) 
		and c:GetEquipGroup():IsExists(cm.eqspfilter,1,nil) 
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local tc=g:GetFirst()
	local og=tc:GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(c,tc)
end
--adjust
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if g:GetCount()==0 and (c:IsAbleToDeck() or c:IsAbleToExtra()) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.Readjust()
	end
end
--Effect 1
function cm.filter(c,ec)
	return c:IsSetCard(0x129) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetRange(LOCATION_SZONE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e4)
		tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
--Effect 2
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
	and rc:IsSetCard(0x129)
	and rc:IsControler(tp)
	and not rc:IsType(TYPE_EQUIP)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	if  rc:IsLocation(LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE) then
		e:SetLabelObject(rc)
	else
		e:SetLabelObject(0)
	end
end
function cm.label(c,tc)
	return c==tc and c:IsLocation(LOCATION_REMOVED) and c:IsCanOverlay()
end
function cm.labelj(c,tc)
	return c==tc and c:IsLocation(LOCATION_GRAVE) and c:IsCanOverlay()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.label,1,nil,tc) and tc~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	local mg=eg:Filter(cm.label,nil,tc)
	if chk==0 then return tc~=0 and #mg~=0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	local mg=eg:Filter(cm.label,nil,tc)
	if tc~=0 and #mg~=0 then
		Duel.Overlay(e:GetHandler(),mg)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.labelj,1,nil,tc) and tc~=0
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	local mg=eg:Filter(cm.labelj,nil,tc)
	if chk==0 then return tc~=0 and #mg~=0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	local mg=eg:Filter(cm.labelj,nil,tc)
	if tc~=0 and #mg~=0 then
		Duel.Overlay(e:GetHandler(),mg)
	end
end
--Effect 3 
function cm.copy(c,e)
	return c:IsCanBeEffectTarget(e)
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:CheckActivateEffect(false,true,false)~=nil
		and c:GetFlagEffect(m+5)==0
end
function cm.cytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(cm.copy,nil,e)
	if chkc then return false end
	if chk==0 then
		return g:GetCount()>0 and e:GetHandler():GetFlagEffect(m+2)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local mg=g:FilterSelect(tp,cm.copy,1,1,nil,e)
	Duel.HintSelection(mg)
	local te=mg:GetFirst():CheckActivateEffect(false,true,false)
	e:SetLabelObject(te)
	e:SetLabel(mg:GetFirst():GetCode())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:GetHandler():RegisterFlagEffect(m+2,RESET_CHAIN,0,1)
	e:GetHandler():RegisterFlagEffect(m+7,RESET_EVENT+RESETS_STANDARD,0,75)
	local tg=te:GetTarget()
	local re=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:GetHandler():RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
	else
		e:GetHandler():RegisterFlagEffect(m+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,1,0)
	end
end
function cm.dhlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.cyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabel()
	local te=e:GetLabelObject()
	local g=c:GetOverlayGroup():Filter(cm.copy,nil,e) 
	if not te or g:GetCount()==0 then return end
	if c:IsFaceup()  then
		local op=te:GetOperation()
		if op then
			local re=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
			op(e,tp,eg,ep,ev,re,r,rp) 
		end
		local code=tc
		local mg=c:GetOverlayGroup():Filter(cm.name,nil,code) 
		local mg1=Duel.GetMatchingGroup(cm.name,tp,0xff,0,nil,code)
		if #mg~=0 or #mg1~=0 then
			mg:Merge(mg1)
			local tc1=mg:GetFirst()
			while tc1 do
				tc1:RegisterFlagEffect(m+5,RESET_PHASE+PHASE_END,0,1)
				tc1=mg:GetNext()
			end
		end
	end
end
function cm.name(c,code)
	return c:IsCode(code)
end
--Effect 4 
function cm.todeckcon(e,tp,eg,ep,ev,re,r,rp)
	local tid=e:GetHandler():GetFlagEffectLabel(m+3)
	return tid and tid~=Duel.GetTurnCount()
end
function cm.todeck(c)
	return  c:IsAbleToDeck()
end
function cm.todecktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.todeckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(m+7)
	local g=c:GetOverlayGroup():Filter(cm.todeck,nil) 
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
