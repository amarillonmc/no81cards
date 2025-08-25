--救世之章 强能
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,s.mfilter,nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),1,99)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60461804,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.seqtg)
	e1:SetOperation(s.seqop)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.dicecon)
	e2:SetOperation(s.diceop)
	c:RegisterEffect(e2)
end
function s.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function s.exmzfilter(c,seq)
	return c:GetSequence()==seq
end
function s.seqfilter(c,seq,tp)
	local cseq=c:GetSequence()
	local p=c:GetControler()
	if tp==p then
		return cseq==seq or seq<5 and cseq<5 and c:IsLocation(LOCATION_MZONE) and math.abs(cseq-seq)==1 or seq==1 and cseq==5 or seq==3 and cseq==6
	else
		return seq==3 and cseq==5 or seq==1 and cseq==6
	end
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local filter=0
	for p=0,1 do
		for i=0,4 do
			if not Duel.IsExistingMatchingCard(s.seqfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,i,p) then
				local zone=2^i
				if tp~=p then zone=zone<<16 end
				filter=filter|zone
			end
		end
	end
	for i=5,6 do
		if not Duel.IsExistingMatchingCard(s.seqfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,i,tp) then
			local zone=2^i+2^(27-i)
			filter=filter|zone
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	e:SetLabel(flag)
	local p=tp
	local seq=math.log(flag,2)
	if flag==200040 then seq=5
	elseif flag==400020 then seq=6
	elseif flag>0xffff then
		p=1-tp
		seq=seq-16
	end
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,p)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local flag=e:GetLabel()
	local p=tp
	local seq=math.log(flag,2)
	if flag==0x200040 then seq=6
	elseif flag==0x400020 then seq=5
	elseif flag>0xffff then
		p=1-tp
		seq=seq-16
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,p)
	Duel.HintSelection(g)
	local lv=c:GetLevel()
	if lv and lv>0 and Duel.TossDice(1-tp,1)<lv then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function s.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) and Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local originalDc=dc
		local ct=(ev&0xff)+(ev>>16&0xff)
		local ac=1
		local availablePositions={}
		for i=1,ct do
			table.insert(availablePositions,i)
		end
		local selectedPositions={}
		while #availablePositions>0 do
			local position=availablePositions[1]
			if #availablePositions>1 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
				position=Duel.AnnounceNumber(tp,table.unpack(availablePositions))
			end
			table.insert(selectedPositions,position)
			for i = #availablePositions, 1, -1 do
				if availablePositions[i] == position then
					table.remove(availablePositions, i)
					break
				end
			end
			if #availablePositions>0 and not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				break
			end
		end
		if ct>#selectedPositions then
			table.sort(selectedPositions)
			local modifyMessage = "玩家修改了"
			for i,pos in ipairs(selectedPositions) do
				if i>1 then
					if i==#selectedPositions then
						modifyMessage=modifyMessage.."和"
					else
						modifyMessage=modifyMessage.."，"
					end
				end
				modifyMessage=modifyMessage.."第"..pos.."个（"..originalDc[pos].."）"
			end
			modifyMessage=modifyMessage.."骰子"
			Debug.Message(modifyMessage)
		end
		local newDice={Duel.TossDice(ep,#selectedPositions)}
		for i,pos in ipairs(selectedPositions) do
			dc[pos]=newDice[i]
		end
		Duel.SetDiceResult(table.unpack(dc))
	end
end