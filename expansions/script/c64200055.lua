--“愉乐契骑” 爱妮慕丝
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x64a),13,true)
	--确认		
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.dkcon)
	e1:SetTarget(s.dktg)
	e1:SetOperation(s.dkop)
	c:RegisterEffect(e1)
	--不被取对象	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--放置	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.pencon)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
	--选择发动   
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END+TIMINGS_CHECK_MONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(s.efcost)
	e4:SetTarget(s.eftg)
	e4:SetOperation(s.efop)
	c:RegisterEffect(e4)
end
function s.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.dkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc:IsSetCard(0x64a) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsCode(64200020) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(3600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	else	
		Duel.ShuffleDeck(tp)
	end
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.costfilter(c)
	return c:IsSetCard(0x64a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local b1=Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToGrave,nil)>0 
	local b2=g:GetCount()>0
	local b3=(b1 and b2)
	if chk==0 then return (b1 or b2 or b3) end
	local sel=0
	local ac=0
	if b1 then sel=sel+1 end
	if b2 then sel=sel+2 end
	if sel==1 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,3))
		e:SetCategory(CATEGORY_DECKDES)
	elseif sel==2 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,4))+1
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif b3 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4),aux.Stringid(id,2))
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		ac=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	e:SetLabel(ac)
end
function s.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(7) and c:IsAbleToGrave()
end
function s.desfilter1(c,lv)
	return c:IsFaceup() and not c:IsLevel(lv) and not c:IsType(TYPE_XYZ+TYPE_LINK)
end
function s.desfilter2(c,rk)
	return c:IsFaceup() and not c:IsRank(rk) and c:IsType(TYPE_XYZ)
end	
function s.desfilter3(c,lk)
	return c:IsFaceup() and not c:IsLink(lk) and c:IsType(TYPE_LINK)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	if ac==0 or ac==2 then
		if Duel.IsPlayerCanDiscardDeck(tp,3) then
			Duel.ConfirmDecktop(tp,3)
			local g=Duel.GetDecktopGroup(tp,3)
			local ct=0
			if g:GetCount()>0 then
				if g:IsExists(s.tgfilter,1,nil) then
					local tg=g:Filter(s.tgfilter,nil)
					Duel.DisableShuffleCheck()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=tg:Select(tp,1,tg:GetCount(),nil)
					Duel.SendtoGrave(sg,REASON_EFFECT)		  
					ct=g:GetCount()-sg:GetCount()
				end
				if ct>0 then
					Duel.SortDecktop(tp,tp,ct)
					for i=1,ct do
						local mg=Duel.GetDecktopGroup(tp,1)
						Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
					end	
				end   
			end				 
		end	 
	end
	if ac==1 or ac==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		local dg1=g1:Select(tp,1,1,nil)
		local tc=dg1:GetFirst()
		local g2=0
		if tc:IsLevelAbove(1) then 
			local lv=tc:GetLevel()
			g2=Duel.GetMatchingGroup(s.desfilter1,tp,0,LOCATION_MZONE,tc,lv)
		elseif tc:IsRankAbove(1) then
			local rk=tc:GetRank()
			g2=Duel.GetMatchingGroup(s.desfilter2,tp,0,LOCATION_MZONE,tc,rk)
		elseif tc:IsLinkAbove(1) then
			local rk=tc:GetLink()
			g2=Duel.GetMatchingGroup(s.desfilter3,tp,0,LOCATION_MZONE,tc,lk)		
		end			
		if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg2=g2:Select(tp,1,1,nil)
			dg1:Merge(dg2)
		end	
		if g1:GetCount()>0 then
			Duel.HintSelection(dg1)
			Duel.Destroy(dg1,REASON_EFFECT)
		end
	end
end