--结约之地 卢维亚大教堂
VHisc_Dragonk=VHisc_Dragonk or {}
---------------Functions and Filters--------------------

---------------Register grave remove effect---------------
function VHisc_Dragonk.rmeq(ce,cid)
	--equip
	local e3=Effect.CreateEffect(ce)
	e3:SetDescription(aux.Stringid(cid,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,cid+10000)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(VHisc_Dragonk.eqtg)
	e3:SetOperation(VHisc_Dragonk.eqop)
	ce:RegisterEffect(e3)
end
function VHisc_Dragonk.eqof(c)
	return c:IsFaceup() and c.VHisc_DragonCovenant
end
function VHisc_Dragonk.eqfilter(c)
	return c.VHisc_DragonRelics and c:IsType(TYPE_EQUIP)
end
function VHisc_Dragonk.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and VHisc_Dragonk.eqof(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(VHisc_Dragonk.eqof,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(VHisc_Dragonk.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,VHisc_Dragonk.eqof,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function VHisc_Dragonk.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(VHisc_Dragonk.eqfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
		local ec=g:GetFirst()
		if Duel.Equip(tp,ec,tc) then 
			if ec:IsPreviousLocation(LOCATION_GRAVE) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_DECKSHF)
				ec:RegisterEffect(e1,true)
			end
			local g=Duel.GetMatchingGroup(function(ec) return ec:IsXyzSummonable(nil) and ec.VHisc_DragonCovenant end,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33201250,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		end
	end
end


---------------Register deck_to_hand effect---------------
function VHisc_Dragonk.dthef(ce,cid)
	local e2=Effect.CreateEffect(ce)
	e2:SetDescription(aux.Stringid(33201250,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,cid)
	e2:SetCost(VHisc_Dragonk.dthcost)
	e2:SetTarget(VHisc_Dragonk.dthtg)
	e2:SetOperation(VHisc_Dragonk.dthop)
	ce:RegisterEffect(e2)
end
function VHisc_Dragonk.dthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function VHisc_Dragonk.dthfilter(c)
	return ((c.VHisc_DragonCovenant and c:IsType(TYPE_MONSTER) and not c:IsLevel(2)) or (c.VHisc_DragonRelics and c:IsType(TYPE_EQUIP))) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function VHisc_Dragonk.dthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(VHisc_Dragonk.dthfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function VHisc_Dragonk.dthop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(VHisc_Dragonk.dthfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		sg1:RemoveCard(tc)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end


---------------Equip active---------------
function VHisc_Dragonk.eqa(ce)
	--Activate
	local e0=Effect.CreateEffect(ce)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(VHisc_Dragonk.eqatg)
	e0:SetOperation(VHisc_Dragonk.eqaop)
	ce:RegisterEffect(e0)
	--Equip limit
	local e5=Effect.CreateEffect(ce)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(VHisc_Dragonk.eqlimit)
	ce:RegisterEffect(e5)
end
function VHisc_Dragonk.eqlimit(e,c)
	return c.VHisc_DragonCovenant
end
function VHisc_Dragonk.eqft(c)
	return c:IsFaceup() and c.VHisc_DragonCovenant
end
function VHisc_Dragonk.eqatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and VHisc_Dragonk.eqft(chkc) end
	if chk==0 then return Duel.IsExistingTarget(VHisc_Dragonk.eqft,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,VHisc_Dragonk.eqft,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function VHisc_Dragonk.eqaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
---------------Equip effect---------------
function VHisc_Dragonk.eqgef(ce,gef)
	local e4=Effect.CreateEffect(ce)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(VHisc_Dragonk.eftg)
	e4:SetLabelObject(gef)
	ce:RegisterEffect(e4)
end
function VHisc_Dragonk.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end


------------------------------XYZ summon rule------------------------------
function VHisc_Dragonk.xyzsm(ce,cid) 
	ce:EnableReviveLimit()  
	--special summon rule
	local e0=Effect.CreateEffect(ce)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabel(cid)
	e0:SetCondition(VHisc_Dragonk.spcon)
	e0:SetOperation(VHisc_Dragonk.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	ce:RegisterEffect(e0)
	--equip gain
	local e10=Effect.CreateEffect(ce)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetRange(LOCATION_EXTRA)
	e10:SetCode(EFFECT_SEND_REPLACE)
	e10:SetTarget(VHisc_Dragonk.xyzeqtg)
	e10:SetValue(function(e,c)return c:GetFlagEffect(33201250)>0 end)
	ce:RegisterEffect(e10)
end
--xyz
function VHisc_Dragonk.ovfilter(c,catt)
	return c:IsFaceup() and c.VHisc_DragonCovenant and c:IsAttribute(catt) and c:IsLevel(4) and c:GetEquipGroup():IsExists(function(ec) return ec.VHisc_DragonRelics end,1,nil)
end
function VHisc_Dragonk.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local id=e:GetLabel()
	return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(VHisc_Dragonk.ovfilter,tp,LOCATION_MZONE,0,1,nil,c:GetOriginalAttribute())
end
function VHisc_Dragonk.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local id=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,VHisc_Dragonk.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,c:GetOriginalAttribute())
	local mc=g:GetFirst()
	local mg=mc:GetOverlayGroup()
	local eqg=mc:GetEquipGroup()
	eqg:ForEach(Card.RegisterFlagEffect,id,RESET_EVENT+0x7e0000,0,1)
	c:RegisterFlagEffect(33201249,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetOperation(VHisc_Dragonk.xyzeqop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(e2)
	e3:SetOperation(VHisc_Dragonk.xyzeqop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+33201250)
	e4:SetLabelObject(e3)
	e4:SetOperation(VHisc_Dragonk.xyzeqop3)
	Duel.RegisterEffect(e4,tp)
	if mg:GetCount()~=0 then
		Duel.Overlay(c,mg)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	eqg:ForEach(Card.ResetFlagEffect,id)
	Duel.Hint(24,0,aux.Stringid(33201250,0))
	Duel.Hint(24,0,aux.Stringid(id,0))
end
function VHisc_Dragonk.xyzeqtg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=eg:Filter(function(c,ec)return c:IsType(TYPE_EQUIP) and c:IsReason(REASON_LOST_TARGET) and c:CheckEquipTarget(ec) and c:GetFlagEffect(ec:GetCode())>0 end,nil,c)
	if chk==0 then return #g>0 end
	for ec in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		ec:RegisterEffect(e1)
	end
	g:ForEach(Card.RegisterFlagEffect,33201250,RESET_EVENT+0x7e0000,0,1)

	return true
end
function VHisc_Dragonk.xyzeqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(33201250)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for ec in aux.Next(g) do
		ec:ResetFlagEffect(33201250)
		ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
	end
	Duel.Destroy(g,REASON_RULE)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+33201250,re,r,rp,ep,ev)
	e:GetHandler():ResetFlagEffect(33201249)
	e:Reset()
end
function VHisc_Dragonk.xyzeqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(33201250)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 and c:GetFlagEffect(33201249)>0 then
		for ec in aux.Next(g) do
			Duel.Equip(tp,ec,c)
			ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
			ec:ResetFlagEffect(33201250)
		end
	end
	c:ResetFlagEffect(33201249)
	e:GetLabelObject():Reset()
	e:Reset()
end
function VHisc_Dragonk.xyzeqop3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(33201249)
	e:GetLabelObject():Reset()
	e:Reset()
end
------------------------------------------------------------------------------------------


-------------------------card effect------------------------------

local m=33201250
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EQUIP))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--SearchCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c.VHisc_DragonCovenant and c:IsControler(tp)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and (c.VHisc_DragonCovenant or c.VHisc_DragonRelics)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5):Filter(cm.thfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		end
	end
	Duel.ShuffleDeck(p)
end