--神造遗物使 与一
function c72409025.initial_effect(c)
   --spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72409025)
	e1:SetCondition(c72409025.spcon)
	e1:SetOperation(c72409025.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--equip change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72409025,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,72409026)
	e3:SetCondition(c72409025.eqcon)
	e3:SetTarget(c72409025.eqtg)
	e3:SetOperation(c72409025.eqop)
	c:RegisterEffect(e3)
end

function c72409025.spfilter2(c)
	return  c:IsSetCard(0xe729) and c:IsDestructable() and c:GetOriginalLevel()==3
end
function c72409025.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c72409025.spfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c72409025.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c72409025.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local ca1=g1:GetFirst()
	local geq=Card.GetEquipGroup(ca1)
	local n=Group.GetCount(geq)
	Duel.Destroy(g1,REASON_COST+REASON_RULE)
	Duel.Draw(tp,n,REASON_COST)
end
function c72409025.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() 
end
function c72409025.eqfilter1(c,e)
	return  c:GetEquipTarget()==e:GetOwner()
		and Duel.IsExistingTarget(c72409025.eqfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function c72409025.eqfilter2(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c72409025.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c72409025.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c72409025.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
	local tc=g1:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c72409025.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc:GetEquipTarget(),tc)
end
function c72409025.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) and ec:CheckEquipTarget(tc) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,ec,tc)
	end
end