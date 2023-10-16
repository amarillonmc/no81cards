--魔偶甜点·甜甜饼大厨
local cm,m=GetID()

function cm.initial_effect(c)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
    local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(42620060,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(cm.retcon)
	e7:SetTarget(cm.rettg)
	e7:SetOperation(cm.retop)
	c:RegisterEffect(e7)
end

function cm.filter(c,e,tp)
	return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsRace(RACE_WARRIOR) and c:GetBaseDefense()>0 and c:IsFaceup()
end

function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0x30,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end

function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,0x30,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and tc:IsFaceup() and tc:IsOnField() then
        local c=e:GetHandler()
        if c:IsRelateToChain() and c:IsFaceup() then
            local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(tc:GetBaseDefense())
			c:RegisterEffect(e1)
        end
	end
end

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():IsPreviousControler(tp)
end

function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end