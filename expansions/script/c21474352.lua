--精灵与精灵之镜
function c21474352.initial_effect(c)
	aux.AddCodeList(c,35563539)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21474352,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c21474352.otcon)
	e2:SetOperation(c21474352.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21474352,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c21474352.thtg)
	e1:SetOperation(c21474352.thop)
	c:RegisterEffect(e1)
end
function c21474352.otfilter(c,tp)
	return c:IsLevel(6) and (c:IsControler(tp) or c:IsFaceup())
end
function c21474352.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21474352.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c21474352.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21474352.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end


function c21474352.filter(c)
	return aux.IsCodeListed(c,35563539) and c:IsAbleToHand()
end
function c21474352.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21474352.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21474352.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21474352.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	
end
function c21474352.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(28553439,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local des=dg:Select(tp,1,1,nil)
		Duel.HintSelection(des)
		Duel.BreakEffect()
		Duel.Destroy(des,REASON_EFFECT)
	end
end
