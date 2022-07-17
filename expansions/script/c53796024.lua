local m=53796024
local cm=_G["c"..m]
cm.name="凭一人之力，打倒亻女白整个世界"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==1 and rc:IsRelateToBattle() and rc:IsControler(tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(1-tp,cm.spfilter,1-tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,1-tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEUP)>0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,1)
		e0:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)return c:IsOriginalCodeRule(e:GetLabel()) and se and se:GetHandler():IsCode(m)end)
		e0:SetLabel(tc:GetOriginalCodeRule())
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local ac=eg:Filter(cm.filter,nil,e,tp):GetFirst()
		if not ac then return end
		Duel.ChainAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		ac:RegisterEffect(e1)
	else
		local g=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0)
		Duel.Destroy(g,REASON_RULE)
	end
end
