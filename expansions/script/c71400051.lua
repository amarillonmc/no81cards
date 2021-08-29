--黑白异梦的协奏
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400051.tg1)
	e1:SetOperation(c71400051.op1)
	e1:SetCondition(c71400051.con1)
	e1:SetDescription(aux.Stringid(71400051,0))
	e1:SetCountLimit(1,71400051)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400051,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,71500051)
	e2:SetCondition(c71400051.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400051.tg2)
	e2:SetOperation(c71400051.op2)
	c:RegisterEffect(e2)
end
function c71400051.tunerfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x714) and c:IsAbleToRemove()
end
function c71400051.nontunerfilter(c)
	return not c:IsType(TYPE_TUNER) and c:IsSetCard(0x714) and c:IsAbleToRemove()
end
function c71400051.fieldsynfilter(c)
	return c:IsSetCard(0x717) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c71400051.con1(e,tp,eg,ep,ev,re,r,rp)
	return yume.YumeCon(e,tp) and Duel.IsExistingMatchingCard(c71400051.fieldsynfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c71400051.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400051.tunerfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c71400051.nontunerfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400051.extrasynfilter(c,e,tp)
	return c:IsSetCard(0x714) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
end
function c71400051.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.GetMatchingGroup(c71400051.tunerfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c71400051.nontunerfilter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local sg1=g1:Select(tp,1,1,nil)
	local sg2=g2:Select(tp,1,2,nil)
	sg1:Merge(sg2)
	local rc=sg1:GetFirst()
	local lv=0
	while rc do
		lv=lv+rc:GetLevel()
		rc=g:GetNext()
	end
	Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	local syng=Duel.GetMatchingGroup(c71400051.extrasynfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	yume.UniquifyCardName(syng)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<1 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if syng:CheckWithSumEqual(Card.GetLevel,lv,1,ft) and Duel.SelectYesNo(tp,aux.Stringid(71400051,2)) then
		Duel.BreakEffect()
		tg=syng:SelectWithSumEqual(tp,Card.GetLevel,lv,1,ft)
		local tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
	end
end
function c71400051.con2(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return yume.YumeCon(e,tp) and de and dp~=tp and re:GetHandler():IsSetCard(0x714) and rp==tp
end
function c71400051.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler(),0x717) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,1-tp,LOCATION_ONFIELD)
end
function c71400051.op2(e,tp,eg,ep,ev,re,r,rp)
	if not yume.IsYumeFieldOnField(tp) then return end
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,0x717)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
end