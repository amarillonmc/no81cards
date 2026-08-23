--第55次基因组混合试验产物
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	--record
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.reccon)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.lcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x1dd)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,200,REASON_EFFECT)
end
function s.filter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsFaceup() and c:IsSetCard(0x1dd) and c:IsLevel(4,8) and c:IsType(TYPE_MONSTER)) then return false end
	local b1=(c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
	local b2=false
	local teg=Blacklotus_GMX_record_effect[c:GetOriginalCode()]
	--[[local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
	Card.IsCanBeSpecialSummoned=(function(sc,se,st,sp,snc,snl,spos,stp,szone)
		if sc:IsLocation(LOCATION_MZONE) then return false end
		return _IsCanBeSpecialSummoned(sc,se,st,sp,snc,snl,spos,stp,szone)
	end)]]
	if teg then 
		for _,te in pairs(teg) do 
			local tg=te:GetTarget()
			if not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then b2=true break end
		end
	end
	--Card.IsCanBeSpecialSummoned=_IsCanBeSpecialSummoned
	return b1 or b2
	  
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local b1=(tc:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)))
	local b2=false
	local teg=Blacklotus_GMX_record_effect[tc:GetOriginalCode()]
	--[[local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
	Card.IsCanBeSpecialSummoned=(function(sc,se,st,sp,snc,snl,spos,stp,szone)
		if sc:IsLocation(LOCATION_MZONE) then return false end
		return _IsCanBeSpecialSummoned(sc,se,st,sp,snc,snl,spos,stp,szone)
	end)]]
	if teg then 
		for _,te in pairs(teg) do 
			local tg=te:GetTarget()
			if not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then b2=true break end
		end
	end
	--Card.IsCanBeSpecialSummoned=_IsCanBeSpecialSummoned
	local op=0
	if not b2 and b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif not b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)) 
	end
	e:SetLabel(op)
	if op==1 then
		Duel.ClearTargetCard()
		tc:CreateEffectRelation(e)
		e:SetLabelObject(tc)
		local te=teg[1]
		if #teg>1 then
			local choose_list={}
			--[[local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
			Card.IsCanBeSpecialSummoned=(function(sc,se,st,sp,snc,snl,spos,stp,szone)
				if sc:IsLocation(LOCATION_MZONE) then return false end
				return _IsCanBeSpecialSummoned(sc,se,st,sp,snc,snl,spos,stp,szone)
			end)]]
			for _,tec in pairs(teg) do 
				local tg=tec:GetTarget()
				if not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then 
					choose_list[#choose_list+1]=tec
				end
			end
			--Card.IsCanBeSpecialSummoned=_IsCanBeSpecialSummoned
			if #choose_list==1 then
				te=choose_list[1]
			end
			if #choose_list>1 then
				local op=0
				local hint_list={}
				for _,tec in pairs(choose_list) do 
					local hint=tec:GetDescription()
					if not hint then
						hint=aux.Stringid(id,8)
						local check_list={CATEGORY_SPECIAL_SUMMON,CATEGORY_TOHAND,CATEGORY_DRAW,CATEGORY_TOGRAVE,CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TODECK,CATEGORY_DAMAGE,CATEGORY_RECOVER,CATEGORY_DISABLE}
						local check_hint_list={1152,1190,aux.Stringid(id,6),1191,aux.Stringid(id,7),1192,1193,1122,1123,1131}
						for i=1,#check_list do
							if tec:IsHasCategory(check_list[i]) then
								hint=check_hint_list[i]
								break
							end
						end
					end
					hint_list[#hint_list+1]=hint
				end
				op=Duel.SelectOption(tp,table.unpack(hint_list))+1
				te=choose_list[op]
			end
		end
		Blacklotus_GMX_record_effect[e]=te
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		--[[local te=g:GetFirst():CheckActivateEffect(true,true,false)
		Duel.ClearTargetCard()
		e:SetProperty(te:GetProperty())
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)]]
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			if aux.NecroValleyNegateCheck(tc) then return end
			if not aux.NecroValleyFilter()(tc) then return end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		end
	else
		local tc=e:GetLabelObject()
		if tc:IsRelateToEffect(e) then
			local te=Blacklotus_GMX_record_effect[e]
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
			Blacklotus_GMX_record_effect[e]=nil
		end
	end
end

--record
function s.rcfilter(c)
	return c:IsSetCard(0x1dd)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		Blacklotus_GMX_record_effect={}
		local g=Duel.GetMatchingGroup(s.rcfilter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local record={}
			function s.record_filter(e)
				local ce=record[#record]
				local op=e:GetOperation()
				if e:IsHasRange(LOCATION_HAND+LOCATION_MZONE) and e:IsHasType(EFFECT_TYPE_IGNITION|EFFECT_TYPE_QUICK_O|EFFECT_TYPE_QUICK_F|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_TRIGGER_F) and not e:IsHasType(EFFECT_TYPE_CONTINUOUS) and (not ce or not op or op~=ce:GetOperation()) then
					record[#record+1]=e:Clone()
				end
				return false
			end
			local rc=tc:IsOriginalEffectProperty(s.record_filter)
			if #record~=0 then Blacklotus_GMX_record_effect[tc:GetOriginalCode()]=record end
			--if tc:IsCode(39706423) and #record~=0 then Debug.Message(#record) end
		end
	end
	e:Reset()
end
