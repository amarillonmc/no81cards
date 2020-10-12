--星光歌剧 凤满Revue
if not pcall(function() require("expansions/script/c65010000") end) then require("script/c65010000") end
local m,cm=rscf.DefineCard(65010586)
function cm.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SUMMON)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.negcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)   
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(rscon.sumtype("adv"))
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3) 
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x9da0)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x9da0)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc,trp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and loc & (LOCATION_MZONE+LOCATION_GRAVE)~=0 and trp~=tp and rscon.excard2(Card.IsSetCard,LOCATION_ONFIELD,0,2,nil,0x9da0)(e,tp)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.nbcon(tp,re) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,0,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(c)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)>0 and re:GetHandler():IsLocation(LOCATION_REMOVED) and c then
		local pos=0
		if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
		if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
		if pos==0 then return end
		if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
			Duel.Summon(tp,c,true,nil,1)
		else
			Duel.MSet(tp,c,true,nil,1)
		end
	end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not rscon.excard2(Card.IsSetCard,LOCATION_MZONE,0,1,nil,0x9da0)(e,tp) then
		Duel.SetChainLimit(cm.chainlm1)
	end
	if not rscon.excard2(Card.IsSetCard,LOCATION_MZONE,0,1,nil,0x9da0)(e,1-tp) then
		Duel.SetChainLimit(cm.chainlm2)
	end 
end
function cm.chainlm1(e,rp,tp)
	return rp~=tp
end
function cm.chainlm2(e,rp,tp)
	return rp==tp
end
