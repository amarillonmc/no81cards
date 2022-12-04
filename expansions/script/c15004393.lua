local m=15004393
local cm=_G["c"..m]
cm.name="取自苍白星海的时间"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf30) and c:IsType(TYPE_SYNCHRO)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local list={}
		local lv=2
		local res=0
		while lv<=4 do
			if Duel.IsPlayerCanSpecialSummonMonster(tp,15004393,0xcf30,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,500,1100,lv,RACE_FIEND,ATTRIBUTE_LIGHT) then
				table.insert(list,lv)
				res=1
			end
			lv=lv+1
		end
		return res==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local list={}
	local lv=2
	local res=0
	while lv<=4 do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15004393,0xcf30,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,500,1100,lv,RACE_FIEND,ATTRIBUTE_LIGHT) then
			table.insert(list,lv)
			res=1
		end
		lv=lv+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local x=Duel.AnnounceNumber(tp,table.unpack(list))
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(re:GetHandler(),REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,15004393,0xcf30,TYPES_NORMAL_TRAP_MONSTER+TYPE_TUNER,500,1100,lv,RACE_FIEND,ATTRIBUTE_LIGHT) then
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP+TYPE_TUNER,ATTRIBUTE_LIGHT,RACE_FIEND,lv,500,1100)
			Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end