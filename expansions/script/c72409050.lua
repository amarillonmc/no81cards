--神造遗物 霸主权能
function c72409050.initial_effect(c)
	aux.AddCodeList(c,72409000)
	aux.AddCodeList(c,72409110)
	c:SetUniqueOnField(1,0,72409050)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c72409050.target)
	e1:SetOperation(c72409050.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c72409050.eqlimit)
	c:RegisterEffect(e2)
	--negate		
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72409050,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,72409050)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c72409050.distg)
	e3:SetOperation(c72409050.disop)
	c:RegisterEffect(e3)
end
--equip
function c72409050.eqlimit(e,c)
	return c:IsCode(72409000,72409110)
end
function c72409050.filter(c)
	return c:IsFaceup() and c:IsCode(72409000,72409110)
end
function c72409050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c72409050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72409050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c72409050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c72409050.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--effect
function c72409050.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,nil,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c72409050.disop(e,tp,eg,ep,ev,re,r,rp)
	local a1=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local ch1=math.max(1,a1)
		if ch1>1 then
			local num={}
			local i=1
			while i<=ch1 do
			num[i]=i
			i=i+1
			end	
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(72409050,1))
		ch1=Duel.AnnounceNumber(tp,table.unpack(num))
		end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tch=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_CHAIN_COUNT)
		if tch>=ch1  and te~=e and Duel.NegateActivation(i) then 
			Duel.SendtoGrave(e:GetOwner(),REASON_EFFECT)
		end
	end
end