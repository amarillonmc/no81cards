--魔偶甜点·巴伐露管理员
local cm,m=GetID()

function cm.initial_effect(c)
    --sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
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

function cm.tgsfilter(c,race)
	return c:IsSetCard(0x71) and c:IsFaceup() and c:IsRace(race)
end

function cm.tgsfilter2(c)
	return c:IsSetCard(0x71) and c:IsType(0x6) and c:IsSSetable()
end

function cm.tgsfilter3(c,e,tp)
	return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,RACE_BEAST) and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x10,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,RACE_FAIRY) and Duel.IsExistingMatchingCard(cm.tgsfilter3,tp,0x10,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0
	if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
    e:SetLabel(op)
    if op==2 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON|e:GetCategory())
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
    end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,RACE_BEAST) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x10,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif op==2 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x04,0,1,nil,RACE_FAIRY) and Duel.GetLocationCount(tp,0x04)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter3,tp,0x10,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
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