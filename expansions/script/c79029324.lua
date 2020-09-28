--罗德岛·部署-莱瓦汀巨影
function c79029324.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029324.actg)
	e1:SetOperation(c79029324.acop)
	c:RegisterEffect(e1) 
	--remove overlay replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029324,1))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c79029324.rcon)
	e1:SetOperation(c79029324.rop)
	c:RegisterEffect(e1)
	if not c79029324.global_check then
		c79029324.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029324))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c79029324.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and c:IsCode(79029325)
end
function c79029324.cofil1(c,e,tp)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c79029324.cofil2(c,e,tp)
	return c:IsSetCard(0x95) and c:IsAbleToRemove()
end
function c79029324.cofil3(c,e,tp)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c79029324.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local xg=Duel.GetMatchingGroup(c79029324.cofil1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029324.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c79029324.cofil2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c79029324.cofil3,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and xg:CheckWithSumGreater(Card.GetLevel,9) end
	local g1=Duel.SelectMatchingCard(tp,c79029324.cofil2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c79029324.cofil3,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)  
	local g3=Group.SelectWithSumGreater(xg,tp,Card.GetLevel,9)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c79029324.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Remove(cg,POS_FACEUP,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c79029324.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	tc:SetMaterial(cg)
	Debug.Message("出发了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029324,2))
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029324,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetTarget(c79029324.rotg)
	e1:SetOperation(c79029324.roop)
	tc:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c79029324.rotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,eg:GetCount()*500)
end
function c79029324.roop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我一个人就够了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029324,4))
	local c=e:GetHandler()
	Duel.Overlay(c,eg)
	Duel.Recover(tp,eg:GetCount()*500,REASON_EFFECT)
end
function c79029324.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xa900) and ep==e:GetOwnerPlayer() and e:GetHandler():IsCanOverlay()
end
function c79029324.rop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("不要多说，我知道。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029324,3))
	Duel.Overlay(re:GetHandler(),e:GetHandler())
end





