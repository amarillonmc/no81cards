--珠泪哀歌族·维萨斯
local m=91010016
local cm=c91010016
function c91010016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)   
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect():IsActivatable(tp,true,true) and (c:IsSetCard(0x181) or aux.IsCodeListed(c,56099748)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
			if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else		 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
					cm.ActivateCard(tc,tp,e)
				if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_EQUIP)) then
				Duel.SendtoGrave(tc,REASON_RULE)
				end
			te:UseCountLimit(tp,1,true) 
	end
end
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.symfil(c,e) 
  return   c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial()  and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)  
end 
function cm.espfil(c,e,tp,mg) 
	return c:IsSynchroSummonable(nil,mg) and mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()	
end   
function cm.espfil2(g,c) 
	return c:IsSynchroSummonable(nil,g) and g:GetSum(Card.GetSynchroLevel,c)==c:GetLevel()  
end  
function cm.symgck(g,e,tp)
	return  Duel.IsExistingMatchingCard(cm.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(cm.symgck,1,99,e,tp)  end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function cm.espfil3(c,g) 
	return c:IsSynchroSummonable(nil,g)  
end 
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.symfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e) 
	local tc=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,g,0,5):GetFirst() 
	local mat1=g:SelectSubGroup(tp,cm.espfil2,false,1,99,tc)  
	if mat1:IsExists(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) end,1,nil) then 
			local cg=mat1:Filter(function(c) return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) end,nil) 
			Duel.ConfirmCards(1-tp,cg)
	end 
	tc:SetMaterial(mat1)		 
	Duel.SendtoDeck(mat1,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO) 
	local p=tp
		for i=1,2 do
		local dg=mat1:Filter(function(c,tp) return c:IsLocation(LOCATION_DECK) and c:IsControler(tp) end,nil,p)
			if #dg>1 then
			Duel.SortDecktop(tp,p,#dg)
			end
				for i=1,#dg do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			p=1-tp
		end
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
	tc:CompleteProcedure()  
end 

function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  and (c:IsSetCard(0x181) or aux.IsCodeListed(c,56099748)) and c:IsFaceup() and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetCondition(cm.setcon)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
end
function cm.fit1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x181)
end
function cm.setcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.fit1,tp,LOCATION_MZONE,0,1,nil)
end