--次元抹杀者 杰塞尔
function c11560306.initial_effect(c)
	c:EnableReviveLimit()
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--atk&def 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c11560306.atkval)
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_SET_BASE_DEFENSE) 
	c:RegisterEffect(e2)  
	--to grave 
	local e3=Effect.CreateEffect(c)   
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,11560306)  
	e3:SetCost(c11560306.tgcost)
	e3:SetTarget(c11560306.tgtg)  
	e3:SetOperation(c11560306.tgop) 
	c:RegisterEffect(e3)	
	--damage
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(11560306,0))
	--e4:SetCategory(CATEGORY_DAMAGE)
	--e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e4:SetCode(EVENT_BATTLE_CONFIRM)
	--e4:SetCondition(c11560306.damcon)
	--e4:SetTarget(c11560306.damtg)
	--e4:SetOperation(c11560306.damop)
	--c:RegisterEffect(e4) 
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end) 
	c:RegisterEffect(e4)
	--sp
--	local e5=Effect.CreateEffect(c) 
--	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
--   e5:SetType(EFFECT_TYPE_QUICK_O)  
--	e5:SetCode(EVENT_FREE_CHAIN) 
--	e5:SetHintTiming(0,TIMING_END_PHASE) 
--	e5:SetRange(LOCATION_MZONE)
--	e5:SetCountLimit(1,13760306) 
--	e5:SetTarget(c11560306.sptg) 
--	e5:SetOperation(c11560306.spop)
--	c:RegisterEffect(e5)

	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)  
	e5:SetCode(EVENT_FREE_CHAIN) 
	e5:SetHintTiming(0,TIMING_END_PHASE) 
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCountLimit(1,13760306)
	e5:SetCost(c11560306.sspcost) 
	e5:SetTarget(c11560306.ssptg) 
	e5:SetOperation(c11560306.sspop)
	c:RegisterEffect(e5)
end
c11560306.SetCard_XdMcy=true  
function c11560306.atkval(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)*300 
end 
function c11560306.tgcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) and g:GetCount()>0 and g:GetCount()==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) and Duel.IsPlayerCanDiscardDeck(1-tp,g:GetCount()) end 
	Duel.PayLPCost(tp,1000)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	local tc=g:GetFirst()
	local ctype=0
	while tc do
		for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
		end
		tc=g:GetNext()
	end
	--Duel.SetChainLimit(c11560306.chlimit(ctype)) 
	e:SetLabel(g:GetCount())
end 
function c11560306.chlimit(ctype)
	return function(e,ep,tp) 
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
function c11560306.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end 
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,e:GetLabel()) 
end 
function c11560306.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=e:GetLabel() 
	if x>0 then 
	Duel.DiscardDeck(1-tp,x,REASON_EFFECT)
	end 
end 
function c11560306.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c11560306.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBaseAttack())
end
function c11560306.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local atk=c:GetBaseAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c11560306.spfilter(c,e,tp,ritc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_REMOVED)
		and c:GetReason()&(REASON_RITUAL+REASON_MATERIAL)==(REASON_RITUAL+REASON_MATERIAL) and c:GetReasonCard()==ritc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11560306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return e:GetHandler():IsAbleToDeck() 
	and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and mg:FilterCount(c11560306.spfilter,nil,e,tp,c)==ct end
	Duel.SetTargetCard(mg) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)   
end 
function c11560306.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<mg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and mg:GetCount()~=1 then return end 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 



function c11560306.sspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c11560306.sspfilter(c,e,tp)
	return c.SetCard_XdMcy and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11560306.gselect(g,ft)
	local aaa=3
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>3 then ft=3 end 
	if aaa>ft then aaa=ft end
	return g:CheckWithSumEqual(Card.GetLevel,12,1,aaa) and 
	  g:GetCount()<=ft and g:GetSum(Card.GetLevel)<=12
end
function c11560306.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
--	local aaa=3
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c11560306.sspfilter,tp,LOCATION_REMOVED,0,e:GetHandler(),e,tp)
	if chk==0 then return g:CheckSubGroup(c11560306.gselect,1,3,ft) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c11560306.sspop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>3 then ft=3 end 
	local sg=Duel.GetMatchingGroup(c11560306.sspfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,c11560306.gselect,false,1,ft,ft)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end





