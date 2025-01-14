--飞球造物·吸血球
local m=13254058
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCost(cm.spcost1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	
	elements={{"tama_elements",{{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,1},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_CHAOS,3}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tgfilter(c,ec,ct)
	return ct>=0 and c:IsAttackBelow(ec:GetAttack()+ct*300)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local el={{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	local ct=tama.tamas_getElementCount(tama.tamas_sumElements(mg),TAMA_ELEMENT_CHAOS)-1
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tgfilter(chkc,c,ct) end
	if chk==0 then return tama.tamas_isCanSelectElementsForAbove(mg,el) and Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil,c,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,c,ct)
	local atk=g:GetSum(Card.GetAttack)
	local ct=math.ceil((atk-c:GetAttack())/300)

	local el1={{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,1+ct}}
	local sg=tama.tamas_selectElementsMaterial(mg,el1,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local atk=g:GetSum(Card.GetAttack)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_MANA,2},{TAMA_ELEMENT_LIFE,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,c),el)
	mg:RemoveCard(e:GetHandler())
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
