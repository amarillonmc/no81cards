--拓扑逻辑超越枪管轰炸龙
function c21194015.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21194015.con)
	e1:SetOperation(c21194015.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,21194015)
	e2:SetCondition(c21194015.con2)	
	e2:SetTarget(c21194015.tg2)
	e2:SetOperation(c21194015.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,21194016)
	e3:SetCondition(c21194015.con3)
	e3:SetTarget(c21194015.tg3)
	e3:SetOperation(c21194015.op3)
	c:RegisterEffect(e3)
end
function c21194015.con(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local rc=re:GetHandler()
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and rc:IsControler(tp) and rc:IsType(TYPE_LINK) and rc:IsSetCard(0x10f) and lg:IsContains(rc)
end
function c21194015.op(e,tp,eg,ep,ev,re,r,rp)
	local ttc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,re)
	if #ttc<=0 then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,12,12,ttc)	
	if #g>0 then
	local reop=re:GetOperation()
	local op = function(e,tp,eg,ep,ev,re,r,rp)
		reop(e,tp,eg,ep,ev,re,r,rp)
		local tttc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local ddg=Duel.GetMatchingGroup(aux.TRUE,tp,12,12,tttc)
			if #tttc>0 and #ddg>0 and Duel.SelectYesNo(tp,aux.Stringid(21194015,0)) then
			Duel.Hint(3,tp,HINTMSG_DESTROY)
			local dg=ddg:Select(tp,1,1,tttc)
			Duel.HintSelection(dg)
			dg:Merge(tttc)
			Duel.Destroy(dg,REASON_EFFECT)
			end	
		end
	Duel.ChangeChainOperation(ev,op)
	end
end
function c21194015.q(c,lg)
	return lg:IsContains(c)
end
function c21194015.con2(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return #lg>0 and eg:IsExists(c21194015.q,1,e:GetHandler(),lg)
end
function c21194015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,12)
	if chk==0 then return #g>0 end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c21194015.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,12)
	if c:IsDestructable(e) and c:IsRelateToEffect(e) then g:AddCard(c) end
	if #g>0 then
	Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21194015.w(c,tp)
	return not c:IsCode(21194015) and c:IsPreviousControler(tp) and c:IsPreviousLocation(4) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and (c:IsSetCard(0x16e) or c:IsSetCard(0x10f))
end
function c21194015.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21194015.w,1,nil,tp)
end
function c21194015.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and Duel.GetFieldGroupCount(tp,12,12)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end
function c21194015.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,4)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	local g=Duel.GetFieldGroup(tp,12,12)
		if #g>=2 then
		Duel.Hint(3,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,2,2,nil)
			if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end	
end