--霞之谷的执行者
local s,id,o=GetID()
function s.initial_effect(c)
	BLACKLOTUS_MIST_VALLEY_GTH = 7413427
	--grave to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(BLACKLOTUS_MIST_VALLEY_GTH)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(id)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--tohand
	--[[local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)]]
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--
	if not Blacklotus_Mist_Valley_Initialization then
		Blacklotus_Mist_Valley_Initialization=true
		--handtrap check
		local ge01=Effect.CreateEffect(c)
		ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge01:SetCode(EVENT_ADJUST)
		ge01:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge01,0)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x37) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() and aux.NecroValleyFilter()(tc)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Group.FromCards(c,tc)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		--[[if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			for sc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetAbsoluteRange(tp,1,0)
				e1:SetTarget(s.splimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1,true)
				sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
			end
		end]]
	end
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsLocation(LOCATION_EXTRA)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_HAND)
end
function s.setfilter(c)
	return c:IsSetCard(0x37) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and not Duel.IsExistingMatchingCard(s.d2hmatchfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function s.d2hmatchfilter(c,cd)
	return c:IsFaceup() and c:IsCode(cd)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x37) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

---------------------------tohand edit-------------------------------

function s.filter(c)
	return c:IsOriginalSetCard(0x37) and c:IsType(TYPE_MONSTER)
end
function s.gthfilter(c)
	local te=c:IsHasEffect(BLACKLOTUS_MIST_VALLEY_GTH)
	local tp=c:GetControler()
	if not te then return false end
	local val=te:GetValue()
	return Duel.GetFlagEffect(tp,val)==0
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not Blacklotus_Mist_Valley_globle_check then
		Blacklotus_Mist_Valley_globle_check=true
		Mist_Valley_GTH=false
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local Uncopyable_effct_table={}
			cregister=Card.RegisterEffect
			Card.RegisterEffect=function(card,effect,flag)
				if effect then
					local con,cost,tg,op=effect:GetCondition(),effect:GetCost(),effect:GetTarget(),effect:GetOperation()
					if con then 
						effect:SetCondition(function(...)
							Mist_Valley_GTH=effect
							local boolean=con(...)
							Mist_Valley_GTH=false
							return boolean
						end)
					end
					if cost then 
						effect:SetCost(function(...)
							Mist_Valley_GTH=effect
							local boolean=cost(...)
							Mist_Valley_GTH=false
							if boolean then
								return boolean 
							end
						end)
					end
					if tg then 
						effect:SetTarget(function(...)
							Mist_Valley_GTH=effect
							local boolean=tg(...)
							Mist_Valley_GTH=false
							if boolean then
								return boolean 
							end
						end)
					end
					if op then 
						effect:SetOperation(function(...)
							Mist_Valley_GTH=effect
							local boolean=op(...)
							Mist_Valley_GTH=false
							if boolean then
								return boolean 
							end
						end)
					end
					if effect:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
						--Debug.Message(#Uncopyable_effct_table)
						local eff=effect:Clone()
						table.insert(Uncopyable_effct_table,eff)
					end
				end
				return cregister(card,effect,flag)
			end
			tc:ReplaceEffect(tc:GetOriginalCode(),0)
			Card.RegisterEffect=cregister
			if #Uncopyable_effct_table>0 then
				--Debug.Message(#Uncopyable_effct_table)
				for _,effect in pairs(Uncopyable_effct_table) do
					tc:RegisterEffect(effect)
				end
			end
		end
		--
		local MV_Layer=1
		local MV_THC={}
		local FTH_effct_table={}
		local DIsExistingMatchingCard=Duel.IsExistingMatchingCard
		local DIsExistingTarget=Duel.IsExistingTarget
		local DGetMatchingGroup=Duel.GetMatchingGroup
		local DSelectMatchingCard=Duel.SelectMatchingCard
		local DSelectTarget=Duel.SelectTarget
		local GSelectUnselect=Group.SelectUnselect
		local CIsAbleToHand=Card.IsAbleToHand
		local CIsAbleToHandAsCost=Card.IsAbleToHandAsCost
		--
		Card.IsAbleToHand=function(...)
			if MV_Layer>1 then MV_THC[MV_Layer-1]=true end
			return CIsAbleToHand(...)
		end
		Card.IsAbleToHandAsCost=function(...)
			if MV_Layer>1 then MV_THC[MV_Layer-1]=true end
			return CIsAbleToHandAsCost(...)
		end
		Duel.IsExistingMatchingCard=function(func,pl,self,oppo,ct,c_g_n,...)
			if Mist_Valley_GTH and (self&LOCATION_ONFIELD ~=0 or oppo&LOCATION_ONFIELD ~=0) and func then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,c_g_n,...)
				if #Ex_thg<=0 then return DIsExistingMatchingCard(func,pl,self,oppo,ct,c_g_n,...) end
				local c=Ex_thg:GetFirst()
				MV_THC[MV_Layer]=false
				MV_Layer=MV_Layer+1
				pcall(func(c,...))
				MV_Layer=MV_Layer-1
				if MV_THC[MV_Layer] and #Ex_thg>0 then
					local thg=DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
					Ex_thg=Ex_thg:Filter(func,nil,...)
					if #Ex_thg>0 then
						local Merge_thg=Group.__add(thg,Ex_thg)
						if #Merge_thg==#thg then 
							FTH_effct_table[Mist_Valley_GTH]=false
						else
							FTH_effct_table[Mist_Valley_GTH]=true
						end
						return #Merge_thg>=ct
					end
				end
			end
			return DIsExistingMatchingCard(func,pl,self,oppo,ct,c_g_n,...)
		end
		Duel.IsExistingTarget=function(func,pl,self,oppo,ct,c_g_n,...)
			if Mist_Valley_GTH and (self&LOCATION_ONFIELD ~=0 or oppo&LOCATION_ONFIELD~=0) and func then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,c_g_n,...)
				if #Ex_thg<=0 then return DIsExistingMatchingCard(func,pl,self,oppo,ct,c_g_n,...) end
				local c=Ex_thg:GetFirst()
				MV_THC[MV_Layer]=false
				MV_Layer=MV_Layer+1
				pcall(func(c,...))
				MV_Layer=MV_Layer-1
				if MV_THC[MV_Layer] and #Ex_thg>0 then
					local thg=DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
					Ex_thg=Ex_thg:Filter(func,nil,...)
					if #Ex_thg>0 then
						local Merge_thg=Group.__add(thg,Ex_thg)
						if #Merge_thg==#thg then 
							FTH_effct_table[Mist_Valley_GTH]=false
						else
							FTH_effct_table[Mist_Valley_GTH]=true
						end
						return #Merge_thg>=ct
					end
				end
			end
			return DIsExistingTarget(func,pl,self,oppo,ct,c_g_n,...)
		end
		Duel.GetMatchingGroup=function(func,pl,self,oppo,c_g_n,...)
			if Mist_Valley_GTH and (self&LOCATION_ONFIELD ~=0 or oppo&LOCATION_ONFIELD~=0) and func then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,c_g_n,...)
				if #Ex_thg<=0 then return DGetMatchingGroup(func,pl,self,oppo,c_g_n,...) end
				local c=Ex_thg:GetFirst()
				MV_THC[MV_Layer]=false
				MV_Layer=MV_Layer+1
				pcall(func(c,...))
				MV_Layer=MV_Layer-1
				if MV_THC[MV_Layer] and #Ex_thg>0 then
					local thg=DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
					Ex_thg=Ex_thg:Filter(func,nil,...)
					if #Ex_thg>0 then
						local Merge_thg=Group.__add(thg,Ex_thg)
						if #Merge_thg==#thg then 
							FTH_effct_table[Mist_Valley_GTH]=false
						else
							FTH_effct_table[Mist_Valley_GTH]=true
						end
						return Merge_thg
					end
				end
			end
			return DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
		end
		Duel.SelectMatchingCard=function(selp,func,pl,self,oppo,min,max,c_g_n,...)
			if Mist_Valley_GTH and FTH_effct_table[Mist_Valley_GTH] and (self&LOCATION_ONFIELD ~=0 or oppo&LOCATION_ONFIELD ~=0) and func then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,c_g_n,...)
				if #Ex_thg<=0 then return DSelectMatchingCard(selp,func,pl,self,oppo,min,max,c_g_n,...) end
				local c=Ex_thg:GetFirst()
				MV_THC[MV_Layer]=false
				MV_Layer=MV_Layer+1
				pcall(func(c,...))
				MV_Layer=MV_Layer-1
				if MV_THC[MV_Layer] and #Ex_thg>0 then
					local thg=DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
					Ex_thg=Ex_thg:Filter(func,nil,...)
					if #Ex_thg>0 then
						local Merge_thg=Group.__add(thg,Ex_thg)
						local sg=Merge_thg:Select(selp,min,max,c_g_n)
						if #sg>0 then
							for tc in aux.Next(sg) do
								local te=tc:IsHasEffect(BLACKLOTUS_MIST_VALLEY_GTH)
								if te then
									local val=te:GetValue()
									Duel.RegisterFlagEffect(selp,val,RESET_PHASE+PHASE_END,0,1)
								end
							end
						end
						return sg
					end
				end
			end
			return DSelectMatchingCard(selp,func,pl,self,oppo,min,max,c_g_n,...)
		end
		Duel.SelectTarget=function(selp,func,pl,self,oppo,min,max,c_g_n,...)
			if Mist_Valley_GTH and FTH_effct_table[Mist_Valley_GTH] and (self&LOCATION_ONFIELD ~=0 or oppo&LOCATION_ONFIELD ~=0) and func then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,c_g_n,...)
				if #Ex_thg<=0 then return DSelectTarget(selp,func,pl,self,oppo,min,max,c_g_n,...) end
				local c=Ex_thg:GetFirst()
				MV_THC[MV_Layer]=false
				MV_Layer=MV_Layer+1
				pcall(func(c,...))
				MV_Layer=MV_Layer-1
				if MV_THC[MV_Layer] and #Ex_thg>0 then
					local thg=DGetMatchingGroup(func,pl,self,oppo,c_g_n,...)
					Ex_thg=Ex_thg:Filter(func,nil,...)
					if #Ex_thg>0 then
						local Merge_thg=Group.__add(thg,Ex_thg)
						local sg=Merge_thg:Select(selp,min,max,c_g_n)
						if #sg>0 then
							for tc in aux.Next(sg) do
								local te=tc:IsHasEffect(BLACKLOTUS_MIST_VALLEY_GTH)
								if te then
									local val=te:GetValue()
									Duel.RegisterFlagEffect(selp,val,RESET_PHASE+PHASE_END,0,1)
								end
							end
						end
						Duel.SetTargetCard(sg)
						return sg
					end
				end
			end
			return DSelectTarget(selp,func,pl,self,oppo,min,max,c_g_n,...)
		end
		Group.SelectUnselect=function(cg,sg,pl,btok,cancelable,minc,maxc)
			if Mist_Valley_GTH and FTH_effct_table[Mist_Valley_GTH] then
				local Ex_thg=DGetMatchingGroup(s.gthfilter,pl,LOCATION_GRAVE,0,nil)
				if #Ex_thg>0 then
					cg:Merge(Ex_thg)
					local card=GSelectUnselect(cg,sg,pl,btok,cancelable,minc,maxc)
					local te=card:IsHasEffect(BLACKLOTUS_MIST_VALLEY_GTH)
					if te then
						local val=te:GetValue()
						Duel.RegisterFlagEffect(selp,val,RESET_PHASE+PHASE_END,0,1)
					end
					return card
				end
			end
			return GSelectUnselect(cg,sg,pl,btok,cancelable,minc,maxc)
		end
	end
	e:Reset()
end
