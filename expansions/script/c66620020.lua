--绮奏·殛破异律·艾雷缇雅
function c66620020.initial_effect(c)

    -- 自己场上没有怪兽存在的场合或者对方场上有怪兽存在的场合，这张卡可以从手卡特殊召唤，这个回合，自己不是融合怪兽不能从额外卡组特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,66620020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c66620020.spcon)
	e1:SetOperation(c66620020.spop)
	c:RegisterEffect(e1)
	
	-- 这张卡召唤·特殊召唤的场合，以对方场上1只怪兽为对象才能发动，那只怪兽破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620020,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,66620021)
	e2:SetTarget(c66620020.destg)
	e2:SetOperation(c66620020.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	-- 只要这张卡在怪兽区域存在，自己在对方回合可以把「绮奏」速攻魔法卡从手卡发动
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66620020,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666a))
	e4:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e4)
end

-- 自己场上没有怪兽存在的场合或者对方场上有怪兽存在的场合，这张卡可以从手卡特殊召唤，这个回合，自己不是融合怪兽不能从额外卡组特殊召唤
function c66620020.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function c66620020.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66620020.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c66620020.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end

-- 这张卡召唤·特殊召唤的场合，以对方场上1只怪兽为对象才能发动，那只怪兽破坏
function c66620020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c66620020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
