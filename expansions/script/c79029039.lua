--龙门·据点-市中心
function c79029039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029039.target)
	e1:SetOperation(c79029039.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029039.eqlimit)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c79029039.atkcon)
	e3:SetValue(c79029039.atkval)
	c:RegisterEffect(e3)
	--desrep
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c79029039.destg)
	e4:SetOperation(c79029039.desop)
	c:RegisterEffect(e4)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029039.mvcon)
	e3:SetTarget(c79029039.mvtg)
	e3:SetOperation(c79029039.mvop)
	c:RegisterEffect(e3)
end
function c79029039.eqlimit(e,c)
	return c:IsSetCard(0xf02)
end
function c79029039.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL+TYPE_EQUIP)
end
function c79029039.atkval(e,c)
   local c=e:GetHandler():GetEquipTarget()
   if c:IsType(TYPE_XYZ) then return c:GetRank()*c:GetOverlayCount()*-200
   else return c:GetLevel()*-200
end
end
function c79029039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029018.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf02)
end
function c79029039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029039.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg end
	return Duel.SelectEffectYesNo(tp,c,79029096)
end
function c79029039.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c79029039.mvfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xf02)
end
function c79029039.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf02) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c79029039.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function c79029039.mvfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0xf02) and c:GetSequence()<5
end
function c79029039.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029039.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79029039.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	local b2=Duel.IsExistingMatchingCard(c79029039.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(25163979,1),aux.Stringid(25163979,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(25163979,1))
	else op=Duel.SelectOption(tp,aux.Stringid(25163979,2))+1 end
	e:SetLabel(op)
end
function c79029039.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25163979,3))
		local g=Duel.SelectMatchingCard(tp,c79029039.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectMatchingCard(tp,c79029039.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectMatchingCard(tp,c79029039.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
	end
end
