local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.nscon)
	e2:SetTarget(s.nstg)
	e2:SetOperation(s.nsop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_COST)
		ge1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
		ge1:SetTarget(s.costtg)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		s[0]={}
		local f=Duel.Summon
		Duel.Summon=function(sp,sc,...)
			s[0][sc]=sc:GetFieldID()
			return f(sp,sc,...)
		end
	end
end
function s.costtg(e,c,tp)
	e:SetLabelObject(c)
	return true
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if s[0][c] and s[0][c]==c:GetFieldID() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.regop)
	e1:SetReset(RESET_EVENT+0x4fe0000)
	c:RegisterEffect(e1,true)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(e:GetHandler():GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	e:Reset()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	if g:IsExists(Card.IsCode,1,nil,ac) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
	--Extra Summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,ac))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.nscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==2
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end