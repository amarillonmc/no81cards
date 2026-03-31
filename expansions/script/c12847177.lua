--冠位剑士
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--special summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(id)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1191)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	--limit summons
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.lscon)
	e4:SetOperation(s.lsop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.repval)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		grandsaber_table={}
		grandsaber_hackspsummon=Duel.SpecialSummon
		function Duel.SpecialSummon(target,sumtype,sumplayer,tgplayer,check,limit,...)
			if Duel.IsPlayerAffectedByEffect(sumplayer,id)
				and Duel.IsPlayerCanSpecialSummonMonster(sumplayer,id) then
				if aux.GetValueType(target)=="Card" then
					if not target:IsLocation(LOCATION_EXTRA) and target:IsRace(RACE_WARRIOR) and target:GetFlagEffect(id)==0
						and Duel.SelectYesNo(sumplayer,aux.Stringid(id,0)) then
						if not target:IsType(TYPE_TOKEN) then Duel.Hint(HINT_CARD,0,target:GetOriginalCode()) end
						target:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
						Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
						local sg=Duel.SelectMatchingCard(sumplayer,s.spfilter,sumplayer,LOCATION_HAND,0,1,1,nil)
						target=sg:GetFirst()
						target:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
						check=true
						limit=true
						sumtype=0
					end
				elseif aux.GetValueType(target)=="Group" then
					local exg=Group.CreateGroup()
					exg=target:Filter(s.filter0,nil)
					if #exg>0 and Duel.SelectYesNo(sumplayer,aux.Stringid(id,0)) then
						Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_OPERATECARD)
						local cg=exg:Select(sumplayer,1,1,nil)
						if not cg:GetFirst():IsType(TYPE_TOKEN) then Duel.Hint(HINT_CARD,0,cg:GetFirst():GetOriginalCode()) end
						cg:GetFirst():RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
						target:Sub(cg)
						Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
						local sg=Duel.SelectMatchingCard(sumplayer,s.spfilter,sumplayer,LOCATION_HAND,0,1,1,nil)
						sg:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
						target:Merge(sg)
						check=true
						limit=true
						sumtype=0
					end
				end
			end
			return grandsaber_hackspsummon(target,sumtype,sumplayer,tgplayer,check,limit,...)
		end
		grandsaber_hackstep=Duel.SpecialSummonStep
		function Duel.SpecialSummonStep(target,sumtype,sumplayer,tgplayer,check,limit,...)
			if Duel.IsPlayerAffectedByEffect(sumplayer,id)
				and Duel.IsPlayerCanSpecialSummonMonster(sumplayer,id) then
				if not target:IsLocation(LOCATION_EXTRA) and target:IsRace(RACE_WARRIOR) and target:GetFlagEffect(id)==0
					and Duel.SelectYesNo(sumplayer,aux.Stringid(id,0)) then
					if not target:IsType(TYPE_TOKEN) then Duel.Hint(HINT_CARD,0,target:GetOriginalCode()) end
					target:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
					Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tp,s.spfilter,sumplayer,LOCATION_HAND,0,1,1,nil)
					sg:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
					target=sg:GetFirst()
					table.insert(grandsaber_table,target)
					check=true
					limit=true
					sumtype=0
				end
			end
			return grandsaber_hackstep(target,sumtype,sumplayer,tgplayer,check,limit,...)
		end
		grandsaber_hackcheck=Card.IsCanBeSpecialSummoned
		function Card.IsCanBeSpecialSummoned(card,effect,sumtype,sumplayer,check,limit,...)
			if card:GetFlagEffect(id)>0 then
				check=true
				limit=true
				sumtype=0
			end
			return grandsaber_hackcheck(card,effect,sumtype,sumplayer,check,limit,...)
		end
		grandsaber_Equip=Duel.Equip
		function Duel.Equip(player,c,tc,...)
			local g3=Duel.GetMatchingGroup(s.eqfilter,player,LOCATION_MZONE,LOCATION_MZONE,nil)
			if tc:GetFlagEffect(id+1)>0 then
				if #g3>0 then tc=g3:GetFirst() end
				for i,card in ipairs(grandsaber_table) do
					if card:GetFlagEffect(id)>0 then
						tc=card
						break
					end
				end
				grandsaber_table={}
				if tc and grandsaber_Equip(player,c,tc,...) then
					tc:ResetFlagEffect(id+2)
					local ee1=Effect.CreateEffect(tc)
					ee1:SetType(EFFECT_TYPE_SINGLE)
					ee1:SetCode(EFFECT_EQUIP_LIMIT)
					ee1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					ee1:SetReset(RESET_EVENT+RESETS_STANDARD)
					ee1:SetValue(s.eqlimit)
					c:RegisterEffect(ee1)
				end
				return true
			else
				return grandsaber_Equip(player,c,tc,...)
			end
		end
	end
end
function s.filter0(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsLocation(LOCATION_EXTRA) and c:GetFlagEffect(id)==0
end
function s.eqfilter(c)
	return c:GetFlagEffect(id+2)>0
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.spfilter(c)
	return c:IsOriginalCodeRule(id) or c:IsHasEffect(id)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function s.thfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) 
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function s.lscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.lsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local p=e:GetHandler():GetSummonPlayer()
	e:GetHandler():ResetFlagEffect(id)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,p)
	e:GetHandler():RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.repfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Debug.Message(eg:IsExists(s.repfilter,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)) end
	if Duel.SelectYesNo(tp,aux.Stringid(14001430,0)) then
		local g=eg:Filter(s.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,1,nil)
		end
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(aux.FALSE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		return true
	else return false end
end
function s.repval(e,c)
	return false
end