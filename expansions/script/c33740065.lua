--花花变身·动物朋友 杰克灯鬼火：ACT 2
function c33740065.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsSetCard,0x442),aux.dncheck,4,4,c33740065.ovfilter,aux.Stringid(33740065,0))
	--overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33740065,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	e1:SetCondition(c33740065.matcon)
	e1:SetTarget(c33740065.mattg)
	e1:SetOperation(c33740065.matop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33740065.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--overlay
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33740065,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	--e4:SetCost(c33740065.ovcost)
	e4:SetTarget(c33740065.ovtg)
	e4:SetOperation(c33740065.ovop)
	c:RegisterEffect(e4)
end
function c33740065.ovfilter(c)
	return c:IsCode(33700938) and c:IsFaceup()
end
function c33740065.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()<5
end
function c33740065.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c33740065.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) then
		Duel.DisableShuffleCheck()
		if tc:IsCanOverlay() then
			Duel.Overlay(c,tc)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	--[[else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)]]
	end
end
function c33740065.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*700
end
function c33740065.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local og=e:GetHandler():GetOverlayGroup()
	local ct=e:GetHandler():GetOverlayCount()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if chk==0 then
		if not e:IsCostChecked() then return false end
		return ct>0 and e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) and #g>=ct*5 end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	Duel.SetTargetParam(ct)
end
function c33740065.mfilter(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode()) and c:IsCanOverlay()
end
function c33740065.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(tp,ct*5)
	if not c:IsRelateToChain() or g:GetCount()==0 then return end
	Duel.Overlay(c,g:Filter(c33740065.mfilter,nil,g))
end
