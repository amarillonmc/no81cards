--导魔帝 安格玛
function c49811189.initial_effect(c)
	-- 上级召唤规则：可以将1只上级召唤的怪兽解放作上级召唤
	   --summon with 1 tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811189,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c49811189.otcon)
	e4:SetOperation(c49811189.otop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)

	-- 效果①：上级召唤时，除外墓地1张魔法卡，并从卡组加入同名卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811189,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c49811189.thcon)
	e1:SetTarget(c49811189.thtg)
	e1:SetOperation(c49811189.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c49811189.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end

function c49811189.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c49811189.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c49811189.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c49811189.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c49811189.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

-- 效果①：上级召唤的条件
function c49811189.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end

-- 效果①：目标设置
function c49811189.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c49811189.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c49811189.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c49811189.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c49811189.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811189.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c49811189.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local valch=e:GetLabel()
	e:SetLabel(valch,g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	
	if valch==1 and Duel.IsExistingMatchingCard(c49811189.thfilter2,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	end	
end
function c49811189.thop(e,tp,eg,ep,ev,re,r,rp)
	local valch,code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49811189.thfilter,tp,LOCATION_DECK,0,1,2,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if valch==1 and Duel.IsExistingMatchingCard(c49811189.thfilter2,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c49811189.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end	
end

function c49811189.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end