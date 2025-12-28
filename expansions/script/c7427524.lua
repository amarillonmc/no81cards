--超级地球人 幻影侠
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep(c,s.matfilter,5,true)
	c:EnableReviveLimit()
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,s.sprop(c)):SetValue(SUMMON_VALUE_SELF)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52068432,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.matfilter(c)
	return c:IsFusionSetCard(0xdce) and c:IsFusionType(TYPE_MONSTER)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.sprop(c)
	return  function(g)
				local loc=0
				for tc in aux.Next(g) do
					local tc_loc=tc:GetLocation()
					loc=loc|tc_loc
				end
				--
				local cg=g:Filter(Card.IsFacedown,nil)
				if cg:GetCount()>0 then
					Duel.ConfirmCards(1-c:GetControler(),cg)
				end
				local hg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
				if hg:GetCount()>0 then
					Duel.HintSelection(hg)
				end
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
				--spsummon condition
				c:RegisterFlagEffect(id,RESET_EVENT+0xff0000,0,1,loc)
			end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=c:GetFlagEffectLabel(id)
	if chk==0 then return (bit.band(loc,LOCATION_HAND)==0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil))
		and (bit.band(loc,LOCATION_MZONE)==0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil))
		and (bit.band(loc,LOCATION_GRAVE)==0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil))
		and (bit.band(loc,LOCATION_REMOVED)==0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetFlagEffectLabel(id)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	local g4=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if (bit.band(loc,LOCATION_HAND)==0 or g1:GetCount()>0) 
   and (bit.band(loc,LOCATION_MZONE)==0 or g2:GetCount()>0)  
   and (bit.band(loc,LOCATION_GRAVE)==0 or g3:GetCount()>0) 
   and (bit.band(loc,LOCATION_REMOVED)==0 or g4:GetCount()>0) 
	then
		local sg1=Group.CreateGroup()
		local sg2=Group.CreateGroup()
		local sg3=Group.CreateGroup()
		local sg4=Group.CreateGroup()
		if bit.band(loc,LOCATION_HAND)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg1=g1:RandomSelect(tp,1)
		end
		if bit.band(loc,LOCATION_MZONE)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg2=g2:Select(tp,1,1,nil)
		end
		if bit.band(loc,LOCATION_GRAVE)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg3=g3:Select(tp,1,1,nil)
		end
		if bit.band(loc,LOCATION_REMOVED)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg4=g4:Select(tp,1,1,nil)
		end
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		sg1:Merge(sg4)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
