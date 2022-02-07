--动物朋友 西之白虎
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700085.initial_effect(c)
	Senya.AddAttackSE(c,aux.Stringid(33700085,1))
	Senya.AddSummonSE(c,aux.Stringid(33700085,3))
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	 --deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700085,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700085.target)
	e1:SetOperation(c33700085.operation)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33700085.spcon)
	e2:SetOperation(c33700085.spop)
	c:RegisterEffect(e2)
end
function c33700085.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<hg then return false end
		local g=Duel.GetDecktopGroup(tp,hg)
		local result=g:FilterCount(Card.IsAbleToRemove,nil)>0
		return result
	end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700093,2))
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c33700085.operation(e,tp,eg,ep,ev,re,r,rp)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,hg)
	local g=Duel.GetDecktopGroup(p,hg)
	if g:GetCount()>0 then
		if g:GetClassCount(Card.GetCode)==g:GetCount() then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local sg=g:Select(p,1,1,nil)
			if sg:GetFirst():IsAbleToRemove() then
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				local tc=sg:GetFirst()
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetRange(LOCATION_REMOVED)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
				e1:SetCondition(c33700085.thcon)
				e1:SetOperation(c33700085.thop)
				e1:SetLabel(0)
				Duel.RegisterEffect(e1,tp)
			end
			Duel.ShuffleDeck(p)
		else 
			Duel.DisableShuffleCheck()
		end
	end
end
function c33700085.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33700085.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)>0 then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	else
		e:Reset()
	end
end
function c33700085.confilter(c,ec)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsAbleToGraveAsCost() and c:GetLevel()>0 and c:IsSummonableCard()
end
function c33700085.gcheck(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:GetSum(Card.GetLevel)==4
end
function c33700085.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c33700085.confilter,tp,LOCATION_MZONE,0,nil,c)
	return Senya.CheckGroup(mg,c33700085.gcheck,nil,1,4,tp,c)
end
function c33700085.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c33700085.confilter,tp,LOCATION_MZONE,0,nil,c)
	local g=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,mg,c33700085.gcheck,nil,1,4,tp,c)
	Duel.SendtoGrave(g,REASON_COST)
end
