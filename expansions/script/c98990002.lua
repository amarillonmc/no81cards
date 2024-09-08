--义武千秋 关羽
function c98990002.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98990002,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c98990002.ttcon)
	e1:SetOperation(c98990002.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c98990002.setcon)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98990002.discon)
	e3:SetOperation(c98990002.disop)
	c:RegisterEffect(e3)
	--to hand or special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98990002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98990002.target)
	e2:SetOperation(c98990002.operation)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98990002,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98990002+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c98990002.tgcon)
	e3:SetTarget(c98990002.tgtg)
	e3:SetOperation(c98990002.tgop)
	c:RegisterEffect(e3)
end
function c98990002.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c98990002.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98990002.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c98990002.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c98990002.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98990002,0)) then
		Duel.Hint(HINT_CARD,0,98990002)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c98990002.repop)
	end
end
function c98990002.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98990002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
		and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796) end
end
function c98990002.filter(c)
	return (c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,true,false)~=nil) or (c:IsType(TYPE_TRAP) and c:CheckActivateEffect(false,true,false)~=nil) and c:IsAbleToGrave()
end
function c98990002.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g==5 then
		Duel.ConfirmDecktop(tp,5)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tg=g:Filter(c98990002.filter,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(98990002,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=tg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			local te=tc:CheckActivateEffect(true,true,true)	
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and te then
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c98990002.tgoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c98990002.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98990002.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98990002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98990002.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c98990002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.GetMatchingGroup(c98990002.tgfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tg=sg:GetCount()
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g=sg:Select(tp,ft,ft,nil)
	else
		g=sg
	end
	Duel.SSet(tp,sg)
end