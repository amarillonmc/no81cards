--究极异兽-劈斩之纸御剑
function c40008607.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,c40008607.ovfilter,aux.Stringid(40008607,0),3,c40008607.xyzop)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40008607.atkval)
	c:RegisterEffect(e1)   
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c40008607.atkval)
	c:RegisterEffect(e3)  
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008607,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c40008607.spcost)
	e2:SetCountLimit(1)
	e2:SetTarget(c40008607.target)
	e2:SetOperation(c40008607.operation)
	c:RegisterEffect(e2)
end
function c40008607.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(2) and c:GetOverlayCount()>1
end
function c40008607.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008607)==0 end
	Duel.RegisterFlagEffect(tp,40008607,RESET_PHASE+PHASE_END,0,1)
end
function c40008607.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c40008607.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c40008607.filter(c,tp)
	return not c:IsType(TYPE_TOKEN)
end
function c40008607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008607.mtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008607.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectTarget(tp,c40008607.mtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end
function c40008607.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end