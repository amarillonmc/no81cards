--炎狱熔神
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	s.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g3,1,0,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function s.cfilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x2c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex,g3=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	local tc3=g3:GetFirst()
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
		if tc2:IsRelateToEffect(e) and Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)~=0 then
			if tc3:IsRelateToEffect(e) and Duel.SendtoDeck(tc3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
				local sg2=Duel.GetOperatedGroup()
				if sg2:IsExists(s.cfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
				if sg2:IsExists(s.cfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
				if not sg2:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
				local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
				if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					--and Duel.SelectYesNo(tp,aux.Stringid(id,1)) 
					then
					--Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tc=tg:Select(tp,1,1,nil)
					Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end

-----------------synchro summon----------------------

function s.AddSynchroProcedure(c,f1,f2,minc,maxc)
	if maxc==nil then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynCondition(f1,f2,minc,maxc))
	e1:SetTarget(s.SynTarget(f1,f2,minc,maxc))
	e1:SetOperation(s.SynOperation(f1,f2,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function s.SynMaterialFilterExtra(c,syncard)
	return c.IsCanBeSynchroMaterial(syncard) and c:IsSetCard(0x2c)
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	if Duel.GetFlagEffect(tp,id)==0 then
		local mg3=Duel.GetMatchingGroup(s.SynMaterialFilterExtra,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,syncard)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	return mg
end
function s.SynCondition(f1,f2,minct,maxct)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				--
				local smg
				if mg then
					smg=mg
				else
					smg=s.GetSynMaterials(tp,c)
				end
				if smat then smg:AddCard(smat) end
				--
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,smg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,smg)
			end
end
function s.SynTarget(f1,f2,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				--
				local smg
				if mg then
					smg=mg
				else
					smg=s.GetSynMaterials(tp,c)
				end
				if smat then smg:AddCard(smat) end
				--
				local g=nil
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,smg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,smg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function s.SynOperation(f1,f2,minct,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				local reg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				if #reg>0 then
					Duel.Remove(reg,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
					Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
					g:Sub(reg)
					if #g<=0 then return false end
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
