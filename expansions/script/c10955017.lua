--结标淡希
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)   
end
function s.thfilter(c)
	return (c.MoJin or c:IsSetCard(0x23c)) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLP(tp)>=500 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.tgfilter(c)
	return c:IsType(TYPE_SPELL|TYPE_TRAP) and c:IsFaceup()
end
function s.linkfilter(c,e)
	local e1=nil
	--extra material
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	local res=c:IsLinkSummonable(nil) and c:IsCode(5012617)
	if e1 then e1:Reset() end
	return res
end
function s.linkchkfilter(c)
	return c:IsCode(5012617) and c:IsFacedown()
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil) or Duel.IsExistingMatchingCard(s.linkfilter,tp,LOCATION_EXTRA,0,1,nil,e) end
	if exc then e1:Reset() end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=nil
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.linkfilter,tp,LOCATION_EXTRA,0,1,nil,e)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e)
		local tc=g:GetFirst()
		--extra material
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(s.matval)
		tc:RegisterEffect(e1)
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_END)
	ge1:SetLabelObject(e1)
	ge1:SetOperation(s.retop)
	Duel.RegisterEffect(ge1,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local e=e:GetLabelObject()
	if e then e:Reset() end
end
function s.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(5012617) then return false end
	end
	return true  
end
function s.matval(e,lc,mg,c,tp)
	local ct=1
	if Duel.GetTurnPlayer()==tp then ct=2 end
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(s.exmatcheck,ct,nil,lc,tp)
end