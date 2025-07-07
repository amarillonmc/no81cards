--绮奏·幽垂圣乐 芙洛缇安涅
function c66620220.initial_effect(c)

    -- 「绮奏」怪兽＋机械族怪兽
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x666a),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),true)
	c:EnableReviveLimit()
	
	-- 只要这张卡在怪兽区域存在，和这张卡相同纵列的卡的效果无效化
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c66620220.coltg)
	c:RegisterEffect(e1)
	
	-- 融合召唤的这张卡因对方从场上离开的场合，以「绮奏·幽垂圣乐 芙洛缇安涅」以外的自己的墓地·除外状态的1张「绮奏」卡为对象才能发动，那张卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620220,0))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,66620220)
	e2:SetCondition(c66620220.thcon)
	e2:SetTarget(c66620220.thtg)
	e2:SetOperation(c66620220.thop)
	c:RegisterEffect(e2)
end

-- 只要这张卡在怪兽区域存在，和这张卡相同纵列的卡的效果无效化
function c66620220.coltg(e,c)
	local cg=e:GetHandler():GetColumnGroup()
	return c~=e:GetHandler() and cg:IsContains(c)
end

-- 融合召唤的这张卡因对方从场上离开的场合，以「绮奏·幽垂圣乐 芙洛缇安涅」以外的自己的墓地·除外状态的1张「绮奏」卡为对象才能发动，那张卡加入手卡
function c66620220.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function c66620220.filter(c,e,tp)
	return not c:IsCode(66620220) and c:IsFaceupEx() and c:IsSetCard(0x666a) and c:IsAbleToHand()
end

function c66620220.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c66620220.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c66620220.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectTarget(tp,c66620220.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND)
	end
end

function c66620220.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
