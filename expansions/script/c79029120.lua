--乌萨斯·重装干员-古米
function c79029120.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99) 
	--serch
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029120)
	e1:SetCondition(c79029120.lzcon)
	e1:SetTarget(c79029120.lztg)
	e1:SetOperation(c79029120.lzop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71166481,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7902912099999)
	e2:SetTarget(c79029120.xtg)
	e2:SetOperation(c79029120.xop)
	c:RegisterEffect(e2)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(3701074,0))
	e3:SetCountLimit(1)
	e3:SetCondition(c79029120.discon)
	e3:SetTarget(c79029120.distg)
	e3:SetOperation(c79029120.disop)
	c:RegisterEffect(e3)
end
function c79029120.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ))
end
function c79029120.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029120.lztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then local g=Duel.GetDecktopGroup(tp,3)
	   return true end
end
function c79029120.lzop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 Duel.ConfirmDecktop(tp,3)
	  local g=Duel.GetDecktopGroup(tp,3)
		local sg=g:Filter(Card.IsSetCard,nil,0xa900)
		if sg:GetCount()>0 then
	Duel.Overlay(e:GetHandler(),sg) 
	end
end
function c79029120.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa900)
end
function c79029120.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71166481c79029120.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c79029120.xfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029120.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c79029120.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(tc,mg) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c79029120.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c79029120.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=e:GetHandler():GetAttack()/2
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x)
end
function c79029120.disop(e,tp,eg,ep,ev,re,r,rp)
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end












