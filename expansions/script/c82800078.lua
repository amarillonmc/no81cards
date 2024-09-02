--蓬莱山辉夜的宿敌
local s,id,o=GetID()
s.karuya_name_list=true 
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,id)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x863) and c:IsType(TYPE_MONSTER)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local sg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK,0,nil)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local rg=sg:Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function s.posfilter1(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(s.posfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,s.posfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,530)
	local g2=Duel.SelectTarget(tp,s.posfilter1,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atcon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.attg(e,c)
	return c:GetFlagEffect(id)>0 
end
function s.atlimit(e,c)
	return c~=e:GetHandler() and c:GetFlagEffect(id)==0 
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg<2 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,0))
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
			--at limit
			local e1=Effect.CreateEffect(c)
			--e1:SetDescription(aux.Stringid(id,1))
			--e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e1:SetLabelObject(c)
			e1:SetLabel(fid)
			e1:SetCondition(s.atcon)
			e1:SetTarget(s.attg)
			e1:SetValue(s.atlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e5=Effect.CreateEffect(c)
			--e5:SetDescription(aux.Stringid(id,2))
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetCode(EFFECT_UNRELEASABLE_SUM)
			e5:SetRange(LOCATION_MZONE)
			e5:SetLabelObject(c)
			e5:SetLabel(fid)
			e5:SetCondition(s.atcon)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetValue(1)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e6)
			local e7=e5:Clone()
			--e7:SetDescription(aux.Stringid(id,4))
			e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e7:SetValue(s.fuslimit)
			tc:RegisterEffect(e7)
			local e8=e5:Clone()
			--e8:SetDescription(aux.Stringid(id,5))
			e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e8)
			local e10=e5:Clone()
			--e10:SetDescription(aux.Stringid(id,6))
			e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e10)
			--cannot target
			local e11=Effect.CreateEffect(c)
			--e11:SetDescription(aux.Stringid(id,7))
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e11:SetRange(LOCATION_MZONE)
			e11:SetLabelObject(c)
			e11:SetLabel(fid)
			e11:SetCondition(s.atcon)
			e11:SetValue(s.tgoval)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e11)
		end
		local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE+LOCATION_SZONE)
		e2:SetTargetRange(loc,loc)
		e2:SetLabelObject(c)
		e2:SetLabel(fid)
		e2:SetTarget(s.evtg)
		e2:SetValue(s.evalue)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE+LOCATION_SZONE)
		e3:SetTargetRange(1,1)
		e3:SetValue(s.aclimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		--adjust
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_MZONE+LOCATION_SZONE)
		e4:SetOperation(s.adjustop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
end
function s.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function s.adjcfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id)>0 
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.adjcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct~=2 then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		Duel.Readjust()
	end
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:GetFlagEffect(id)>0 and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function s.evtg(e,c)
	return c:GetFlagEffect(id)==0 or c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.evalue(e,re,rp)
	local rc=re:GetHandler()
	return rc:GetFlagEffect(id)>0
end
function s.tgoval(e,re,rp)
	return e:GetHandler()==re:GetHandler()
end
function s.gthfilter(c)
	return c.karuya_name_list==true  and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.gthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
