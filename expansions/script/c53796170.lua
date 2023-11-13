local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(id)
	e1:SetRange(0xff)
	e1:SetCondition(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=e:GetHandler()
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(id+500)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		ge3:SetTargetRange(LOCATION_MZONE,0)
		ge3:SetTarget(aux.TargetBoolFunction(Card.IsCode,39711336,88989706))
		ge3:SetValue(99)
		ge3:SetLabel(id)
		ge3:SetCondition(s.atcon)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetCode(EFFECT_ATTACK_COST)
		ge4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge4:SetTargetRange(1,0)
		ge4:SetCondition(s.atcon)
		ge4:SetOperation(s.atop)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		Duel.RegisterEffect(ge5,1)
		local ge6=ge4:Clone()
		Duel.RegisterEffect(ge6,1)
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge7:SetOperation(s.atrop)
		Duel.RegisterEffect(ge7,0)
		ge4:SetLabelObject(ge7)
		ge6:SetLabelObject(ge7)
		local originalCardFunctions={}
		for funcName,func in pairs(Card) do originalCardFunctions[funcName]=func end
		local originalGroupFunctions={}
		for funcName,func in pairs(Group) do originalGroupFunctions[funcName]=func end
		for funcName,_ in pairs(Card) do
			if type(Card[funcName])=="function" then
				Card[funcName]=function(sc,...)
					if not sc then return originalCardFunctions[funcName](nil,...) end
					if aux.GetValueType(sc)=="Card" then
						local t=s.Replaced
						if t then
							local og,ag=table.unpack(t)
							if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
						end
					end
					if funcName=="IsHasEffect" then
						local le={...}
						local code,cp=le[1],le[2]
						local et={originalCardFunctions[funcName](sc,code,cp)}
						if code==EFFECT_EXTRA_ATTACK_MONSTER or code==EFFECT_EXTRA_ATTACK or code==EFFECT_ATTACK_ALL then
							local res=true
							while res do
								res=false
								for k,v in pairs(et) do if v:GetLabel()==id then table.remove(et,k) res=true break end end
							end
						end
						return table.unpack(et)
					else return originalCardFunctions[funcName](sc,...) end
				end
			end
		end
		local function areCardGroupsEqual(group1,group2)
			if originalGroupFunctions.GetCount(group1)~=originalGroupFunctions.GetCount(group2) then return false end
			for i,card in ipairs(group1) do if card~=group2[i] then return false end end
			return true
		end
		for funcName,_ in pairs(Group) do
			if type(Group[funcName])=="function" then
				Group[funcName]=function(g1,g2,...)
					if not g1 then return originalGroupFunctions[funcName](nil,nil,...) end
					local t=s.Replaced
					if aux.GetValueType(g1)=="Group" then
						if t then
							local og,ag=table.unpack(t)
							if areCardGroupsEqual(g1,og) then g1=ag end
						end
					end
					if not g2 then return originalGroupFunctions[funcName](g1,nil,...) end
					if aux.GetValueType(g2)=="Group" then
						local t=s.Replaced
						if t then
							local og,ag=table.unpack(t)
							if areCardGroupsEqual(g2,og) then g2=ag end
						end
					end
					return originalGroupFunctions[funcName](g1,g2,...)
				end
			end
		end
		Dezard_CreateEffect=Effect.CreateEffect
		Effect.CreateEffect=function(sc)
			local t=s.Replaced
			if t then
				local og,ag=table.unpack(t)
				if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			end
			return Dezard_CreateEffect(sc)
		end
		Dezard_SetLabelObject=Effect.SetLabelObject
		Effect.SetLabelObject=function(e,label)
			local t=s.Replaced
			if t then
				local og,ag=table.unpack(t)
				if aux.GetValueType(label)=="Card" and label==originalGroupFunctions.GetFirst(og) then label=originalGroupFunctions.GetFirst(ag) elseif aux.GetValueType(label)=="Group" and areCardGroupsEqual(label,og) then label=ag end
			end
			return Dezard_SetLabelObject(e,label)
		end
		local originalDuelFunctions={}
		local DuelFunctionsName1={"Destroy","Remove","SendtoGrave","SendtoDeck","SendtoExtraP","ChangePosition","Release","MoveToField","ReturnToField","MoveSequence","RaiseEvent","RaiseSingleEvent","GetControl","ChangeAttacker","ChangeAttackTarget","NegateRelatedChain","NegateSummon","IncreaseSummonedCount","GetTributeGroup","SetSelectedCard","SetTargetCard","ShuffleSetCard","SetFusionMaterial","SetSynchroMaterial","ReleaseRitualMaterial","HintSelection"}
		for _,funcName in ipairs(DuelFunctionsName1) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(tg,...)
				if not tg then return originalDuelFunctions[funcName](nil,...) end
				local t=s.Replaced
				if aux.GetValueType(tg)=="Card" and t then
					local og,ag=table.unpack(t)
					if tg==originalGroupFunctions.GetFirst(og) then tg=originalGroupFunctions.GetFirst(ag) end
				elseif aux.GetValueType(tg)=="Group" and t then
					local og,ag=table.unpack(t)
					if areCardGroupsEqual(tg,og) then tg=ag end
				end
				return originalDuelFunctions[funcName](tg,...)
			end
		end
		local DuelFunctionsName2={"Summon","MSet","SSet","ConfirmCards","CheckMustMaterial","SelectEffectYesNo","SelectPosition","IsPlayerCanSSet","IsPlayerCanFlipSummon","IsPlayerCanRelease","IsPlayerCanRemove","IsPlayerCanSendtoHand","IsPlayerCanSendtoGrave","IsPlayerCanSendtoDeck","CheckChainTarget","ChangeTargetCard","GetMZoneCount"}
		for _,funcName in ipairs(DuelFunctionsName2) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(others,tg,...)
				if not tg then return originalDuelFunctions[funcName](others,nil,...) end
				local t=s.Replaced
				if aux.GetValueType(tg)=="Card" and t then
					local og,ag=table.unpack(t)
					if tg==originalGroupFunctions.GetFirst(og) then tg=originalGroupFunctions.GetFirst(ag) end
				elseif aux.GetValueType(tg)=="Group" and t then
					local og,ag=table.unpack(t)
					if areCardGroupsEqual(tg,og) then tg=ag end
				end
				return originalDuelFunctions[funcName](others,tg,...)
			end
		end
		local DuelFunctionsName3={"SwapSequence","SwapControl","CalculateDamage","GetTributeCount","Overlay","MajesticCopy"}
		for _,funcName in ipairs(DuelFunctionsName3) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(tg1,tg2,...)
				local t=s.Replaced
				if tg1 then
					if aux.GetValueType(tg1)=="Card" and t then
						local og,ag=table.unpack(t)
						if tg1==originalGroupFunctions.GetFirst(og) then tg1=originalGroupFunctions.GetFirst(ag) end
					elseif aux.GetValueType(tg1)=="Group" and t then
						local og,ag=table.unpack(t)
						if areCardGroupsEqual(tg1,og) then tg1=ag end
					end
				end
				if tg2 then
					if aux.GetValueType(tg2)=="Card" and t then
						local og,ag=table.unpack(t)
						if tg2==originalGroupFunctions.GetFirst(og) then tg2=originalGroupFunctions.GetFirst(ag) end
					elseif aux.GetValueType(tg2)=="Group" and t then
						local og,ag=table.unpack(t)
						if areCardGroupsEqual(tg2,og) then tg2=ag end
					end
				end
				return originalDuelFunctions[funcName](tg1,tg2,...)
			end
		end
		local DuelFunctionsName4={"IsCanAddCounter","DiscardHand","GetMatchingGroup","GetMatchingGroupCount","GetFirstMatchingCard","IsExistingMatchingCard","Duel.SelectMatchingCard","CheckReleaseGroup","SelectReleaseGroup","CheckReleaseGroupEx","SelectReleaseGroupEx","GetTargetCount","IsExistingTarget","SelectTarget","SetOperationInfo","IsPlayerCanSummon","IsPlayerCanMSet","Duel.IsPlayerCanSpecialSummon","GetLocationCountFromEx"}
		for _,funcName in ipairs(DuelFunctionsName4) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(others,...)
				local t=s.Replaced
				if not t then return originalDuelFunctions[funcName](others,...) end
				local og,ag=table.unpack(t)
				local t2={...}
				for k,v in pairs(t2) do
					if aux.GetValueType(v)=="Card" and v==originalGroupFunctions.GetFirst(og) then table.insert(t2,k,originalGroupFunctions.GetFirst(ag)) table.remove(t2,k+1) break
					elseif aux.GetValueType(v)=="Group" and areCardGroupsEqual(v,og) then table.insert(t2,k,ag) table.remove(t2,k+1) break end
				end
				return originalDuelFunctions[funcName](others,table.unpack(t2),nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil)
			end
		end
		Dezard_Equip=Duel.Equip
		Duel.Equip=function(tp,c1,c2,...)
			local t=s.Replaced
			if not t then return Dezard_Equip(tp,c1,c2,...) end
			local og,ag=table.unpack(t)
			if c1==originalGroupFunctions.GetFirst(og) then c1=originalGroupFunctions.GetFirst(ag) end
			if c2==originalGroupFunctions.GetFirst(og) then c2=originalGroupFunctions.GetFirst(ag) end
			return Dezard_Equip(tp,c1,c2,...)
		end
		Dezard_SelectTribute=Duel.SelectTribute
		Duel.SelectTribute=function(tp,sc,minc,maxc,mg,...)
			local t=s.Replaced
			if not t then return Dezard_SelectTribute(tp,sc,minc,maxc,mg,...) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_SelectTribute(tp,sc,minc,maxc,mg,...)
		end
		Dezard_SelectFusionMaterial=Duel.SelectFusionMaterial
		Duel.SelectFusionMaterial=function(tp,sc,mg,gc,...)
			local t=s.Replaced
			if not t then return Dezard_SelectFusionMaterial(tp,sc,mg,gc,...) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if areCardGroupsEqual(mg,og) then mg=ag end
			if gc and gc==originalGroupFunctions.GetFirst(og) then gc=originalGroupFunctions.GetFirst(ag) end
			return Dezard_SelectFusionMaterial(tp,sc,mg,gc,...)
		end
		Dezard_SelectSynchroMaterial=Duel.SelectSynchroMaterial
		Duel.SelectSynchroMaterial=function(tp,sc,f1,f2,minc,maxc,smat,mg)
			local t=s.Replaced
			if not t then return Dezard_SelectSynchroMaterial(tp,sc,f1,f2,minc,maxc,smat,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if smat and smat==originalGroupFunctions.GetFirst(og) then smat=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_SelectSynchroMaterial(tp,sc,f1,f2,minc,maxc,smat,mg)
		end
		Dezard_CheckSynchroMaterial=Duel.CheckSynchroMaterial
		Duel.CheckSynchroMaterial=function(sc,f1,f2,minc,maxc,smat,mg)
			local t=s.Replaced
			if not t then return Dezard_CheckSynchroMaterial(sc,f1,f2,minc,maxc,smat,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if smat and smat==originalGroupFunctions.GetFirst(og) then smat=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_CheckSynchroMaterial(sc,f1,f2,minc,maxc,smat,mg)
		end
		Dezard_SelectTunerMaterial=Duel.SelectTunerMaterial
		Duel.SelectTunerMaterial=function(tp,sc,tuner,f1,f2,minc,maxc,mg)
			local t=s.Replaced
			if not t then return Dezard_SelectTunerMaterial(tp,sc,tuner,f1,f2,minc,maxc,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if tuner==originalGroupFunctions.GetFirst(og) then tuner=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_SelectTunerMaterial(tp,sc,tuner,f1,f2,minc,maxc,mg)
		end
		Dezard_CheckTunerMaterial=Duel.CheckTunerMaterial
		Duel.CheckTunerMaterial=function(sc,tuner,f1,f2,minc,maxc,mg)
			local t=s.Replaced
			if not t then return Dezard_CheckTunerMaterial(sc,tuner,f1,f2,minc,maxc,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if tuner==originalGroupFunctions.GetFirst(og) then tuner=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_CheckTunerMaterial(sc,tuner,f1,f2,minc,maxc,mg)
		end
		Dezard_SelectXyzMaterial=Duel.SelectXyzMaterial
		Duel.SelectXyzMaterial=function(tp,sc,f,lv,minc,maxc,mg)
			local t=s.Replaced
			if not t then return Dezard_SelectXyzMaterial(tp,sc,f,lv,minc,maxc,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_SelectXyzMaterial(tp,sc,f,lv,minc,maxc,mg)
		end
		Dezard_CheckTribute=Duel.CheckTribute
		Duel.CheckTribute=function(sc,minc,maxc,mg,...)
			local t=s.Replaced
			if not t then return Dezard_CheckTribute(sc,minc,maxc,mg,...) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_CheckTribute(sc,minc,maxc,mg,...)
		end
		Dezard_CheckXyzMaterial=Duel.CheckXyzMaterial
		Duel.CheckXyzMaterial=function(sc,f,lv,minc,maxc,mg)
			local t=s.Replaced
			if not t then return Dezard_CheckXyzMaterial(sc,f,lv,minc,maxc,mg) end
			local og,ag=table.unpack(t)
			if sc==originalGroupFunctions.GetFirst(og) then sc=originalGroupFunctions.GetFirst(ag) end
			if mg and areCardGroupsEqual(mg,og) then mg=ag end
			return Dezard_CheckXyzMaterial(sc,f,lv,minc,maxc,mg)
		end
		Dezard_SendtoHand=Duel.SendtoHand
		Duel.SendtoHand=function(tg,tp,reason)
			if s.Replaced then return 0 end
			local ag=originalGroupFunctions.__add(tg,tg)
			local g=originalGroupFunctions.Filter(ag,function(c)return c:IsHasEffect(id) and (c:IsAbleToDeck() or not c:IsLocation(LOCATION_DECK))end,nil)
			local re,p=table.unpack(s.chain_solving)
			local rg=originalGroupFunctions.__add(Duel.GetFieldGroup(p,0xff,0),Duel.GetOverlayGroup(p,1,0)):Filter(function(c,res)return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and (res or c:IsCode(88989706))end,ag,s.Fushioh_Check)
			local sg2=Group.CreateGroup()
			if p<2 and #g>0 and #rg>0 and reason&REASON_RULE==0 and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
				Duel.ConfirmCards(1-p,g)
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,1))
				local sg1=g:Clone()
				if #sg1>1 then sg1=g:Select(p,1,math.min(#rg,#g),nil) end
				local tg0=Group.CreateGroup()
				local tg1=Group.CreateGroup()
				for tc in aux.Next(sg1) do if tc:IsControler(0) then tg0:AddCard(tc) else tg1:AddCard(tc) end end
				for tc in aux.Next(tg0) do if tc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(tc,1) tg0:RemoveCard(tc) end end
				if #tg0>0 then Duel.SendtoDeck(tg0,0,1,REASON_RULE) end
				for tc in aux.Next(tg1) do if tc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(tc,1) tg1:RemoveCard(tc) end end
				if #tg1>0 then Duel.SendtoDeck(tg1,1,1,REASON_RULE) end
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,2))
				sg2=rg:Select(p,1,#sg1,nil)
				local og=ag:Clone()
				ag:Sub(sg1)
				ag:Merge(sg2)
				s.Replaced={og,ag}
			end
			return Dezard_SendtoHand(ag,tp,reason)
		end
		Dezard_SpecialSummon=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,st,sp,tgp,bool1,bool2,...)
			if s.Replaced then return 0 end
			local ag=originalGroupFunctions.__add(tg,tg)
			local g=ag:Filter(function(c)return c:IsHasEffect(id) and (c:IsAbleToDeck() or not c:IsLocation(LOCATION_DECK))end,nil)
			local re,p=table.unpack(s.chain_solving)
			local rg=originalGroupFunctions.__add(Duel.GetFieldGroup(sp,0xff,0),Duel.GetOverlayGroup(sp,1,0)):Filter(function(c,res,re,tp,bool1,bool2)return c:IsCanBeSpecialSummoned(re,0,tp,bool1,bool2) and (res or c:IsCode(88989706))end,ag,s.Fushioh_Check,re,sp,bool1,bool2)
			local sg2=Group.CreateGroup()
			if p<2 and #g>0 and #rg>0 and Duel.SelectYesNo(sp,aux.Stringid(id,0)) then
				Duel.ConfirmCards(1-sp,g)
				Duel.Hint(HINT_SELECTMSG,sp,aux.Stringid(id,1))
				local sg1=g:Clone()
				if #sg1>1 then sg1=g:Select(sp,1,math.min(#rg,#g),nil) end
				local tg0=Group.CreateGroup()
				local tg1=Group.CreateGroup()
				for tc in aux.Next(sg1) do if tc:IsControler(0) then tg0:AddCard(tc) else tg1:AddCard(tc) end end
				for tc in aux.Next(tg0) do if tc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(tc,1) tg0:RemoveCard(tc) end end
				if #tg0>0 then Duel.SendtoDeck(tg0,0,1,REASON_RULE) end
				for tc in aux.Next(tg1) do if tc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(tc,1) tg1:RemoveCard(tc) end end
				if #tg1>0 then Duel.SendtoDeck(tg1,1,1,REASON_RULE) end
				Duel.Hint(HINT_SELECTMSG,sp,aux.Stringid(id,2))
				sg2=rg:Select(sp,1,#sg1,nil)
				local og=ag:Clone()
				ag:Sub(sg1)
				ag:Merge(sg2)
				s.Replaced={og,ag}
				Dezard_Sp_Check=true
			end
			return Dezard_SpecialSummon(ag,st,sp,tgp,bool1,bool2,...)
		end
		Dezard_SpecialSummonStep=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(sc,st,sp,tgp,bool1,bool2,...)
			if Dezard_Sp_Check then return false end
			local tc=sc
			local re,p=table.unpack(s.chain_solving)
			local rg=originalGroupFunctions.__add(Duel.GetFieldGroup(sp,0xff,0),Duel.GetOverlayGroup(sp,1,0)):Filter(function(c,res,re,tp,bool1,bool2)return c:IsCanBeSpecialSummoned(re,0,tp,bool1,bool2) and (res or c:IsCode(88989706))end,tc,s.Fushioh_Check,re,sp,bool1,bool2)
			if p<2 and sc:IsHasEffect(id) and (sc:IsAbleToDeck() or not sc:IsLocation(LOCATION_DECK)) and #rg>0 and Duel.SelectYesNo(sp,aux.Stringid(id,0)) then
				Duel.ConfirmCards(1-sp,sc)
				if sc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(sc,1) else Duel.SendtoDeck(sc,sc:GetControler(),1,REASON_RULE) end
				Duel.Hint(HINT_SELECTMSG,sp,aux.Stringid(id,2))
				tc=rg:Select(sp,1,1,nil):GetFirst()
				s.Replaced={Group.FromCards(sc),Group.FromCards(tc)}
			end
			return Dezard_SpecialSummonStep(tc,st,sp,tgp,bool1,bool2,...)
		end
		Dezard_SpecialSummonRule=Duel.SpecialSummonRule
		Duel.SpecialSummonRule=function(sp,sc,st)
			if s.Replaced then return 0 end
			local tc=sc
			local re,p=table.unpack(s.chain_solving)
			local rg=originalGroupFunctions.__add(Duel.GetFieldGroup(sp,0xff,0),Duel.GetOverlayGroup(sp,1,0)):Filter(function(c,res,st)return c:IsSpecialSummonable(st) and (res or c:IsCode(88989706))end,tc,s.Fushioh_Check,st)
			local rg=Duel.GetMatchingGroup(function(c,res,re,tp,st)return c:IsSpecialSummonable(st) and (res or c:IsCode(88989706))end,sp,0xff,0,tc,s.Fushioh_Check,re,sp,st)
			if p<2 and sc:IsHasEffect(id) and (sc:IsAbleToDeck() or not sc:IsLocation(LOCATION_DECK)) and #rg>0 and Duel.SelectYesNo(sp,aux.Stringid(id,0)) then
				Duel.ConfirmCards(1-sp,sc)
				if sc:IsLocation(LOCATION_DECK) then Duel.MoveSequence(sc,1) else Duel.SendtoDeck(sc,sc:GetControler(),1,REASON_RULE) end
				Duel.Hint(HINT_SELECTMSG,sp,aux.Stringid(id,2))
				tc=rg:Select(sp,1,1,nil):GetFirst()
				s.Replaced={Group.FromCards(sc),Group.FromCards(tc)}
			end
			return Dezard_SpecialSummonRule(sp,tc,st)
		end
	end
end
s.chain_solving={nil,2}
s.Replaced=nil
function s.count(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving={re,rp}
	local code1,code2=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if code1==39711336 or code2==39711336 then s.Fushioh_Check=true end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving={nil,2}
	s.Fushioh_Check=false
	s.Replaced=nil
	Dezard_Sp_Check=false
end
function s.atfilter(c)
	return c:IsHasEffect(id+500) and c:IsAbleToGraveAsCost()
end
function s.atcon(e)
	local tp=e:GetHandlerPlayer()
	if not Duel.IsExistingMatchingCard(s.atfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) then return false end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if #g==0 or g:FilterCount(Card.IsHasEffect,1,nil,EFFECT_IGNORE_BATTLE_TARGET)==#g then return false end
	local sg=Duel.GetMatchingGroup(function(c)return c:IsCode(39711336,88989706) and c:IsAttackable() and c:IsFaceup()end,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(sg) do if g:IsExists(Card.IsCanBeBattleTarget,1,nil,tc) then return true end end
	return false
end
function s.atedfilter(c,val,tc,outtg,e,tp)
	local le={c:IsHasEffect(EFFECT_FLAG_EFFECT+(id+500))}
	local ct=0
	for _,te in ipairs(le) do if te:GetLabelObject()==tc then ct=ct+1 end end
	return outtg(e,c,tp) and val>ct
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	if not (c:IsCode(39711336,88989706) and not c:IsImmuneToEffect(e) and Duel.GetFieldGroup(tp,0,LOCATION_MZONE):IsExists(Card.IsCanBeBattleTarget,1,nil,c)) then return end
	local g=Duel.GetMatchingGroup(s.atfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local ct=0
	local t1,t2={c:IsHasEffect(EFFECT_EXTRA_ATTACK)},{c:IsHasEffect(EFFECT_EXTRA_ATTACK_MONSTER)}
	for _,v in ipairs(t2) do table.insert(t1,v) end
	for _,te in ipairs(t1) do
		local val=te:GetValue()
		if aux.GetValueType(val)=="function" then val=val(te,c,tp) end
		ct=math.max(ct,val)
	end
	local ce={c:IsHasEffect(EFFECT_ATTACK_ALL)}
	local outval=0
	local outtg=aux.TRUE
	for _,te in ipairs(ce) do
		local val=te:GetValue()
		if aux.GetValueType(val)=="function" then val=val(te,c,tp) end
		if type(val)~="number" then outtg=te:GetValue() val=1 end
		outval=val
		if Duel.IsExistingMatchingCard(s.atedfilter,tp,0,LOCATION_MZONE,1,nil,val,c,outtg,te,tp) then ct=99 end
	end
	if ct>=c:GetFlagEffect(id+500) and not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then s.Attack_Check=true return end
	s.Attack_Check_2=true
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(sc,REASON_COST)
	sc:CompleteProcedure()
	e:GetLabelObject():SetLabelObject(sc)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(s.val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	e1:SetLabel(id)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(sc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	e2:SetLabel(id)
	c:RegisterEffect(e2,true)
	if s.Attack_Check and #ce>0 then
		local e3=Effect.CreateEffect(sc)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetLabel(id)
		e3:SetValue(s.bttg(outval,outtg))
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e3,true)
	end
	local e4=Effect.CreateEffect(sc)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(function(e,c)return c==Duel.GetAttackTarget() end)
	e4:SetValue(0)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e4,true)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5,true)
	local e6=Effect.CreateEffect(sc)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetTarget(s.postg)
	e6:SetOperation(s.posop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e6,true)
	sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
end
function s.val(e,c)
	return c:GetFlagEffect(id)
end
function s.bttg(outval,outtg)
	return  function(e,c,...)
				local le={c:IsHasEffect(EFFECT_FLAG_EFFECT+(id+500))}
				local ct=0
				for _,te in ipairs(le) do if te:GetLabelObject()==tc then ct=ct+1 end end
				return outtg(e,c,...) and outval<=ct
			end
end
function s.atrop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local t1,t2={at:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK)},{at:IsHasEffect(EFFECT_CANNOT_SELECT_BATTLE_TARGET)}
	for _,v in ipairs(t2) do table.insert(t1,v) end
	for _,v in pairs(t1) do if v:GetLabel()==id then v:Reset() end end
	if s.Attack_Check then at:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1) elseif s.Attack_Check_2 then at:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1) end
	s.Attack_Check=false
	s.Attack_Check_2=false
	local tc=Duel.GetAttackTarget()
	if not tc then return end
	local owner=e:GetLabelObject() or e:GetOwner()
	local e0=Effect.CreateEffect(owner)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FLAG_EFFECT+(id+500))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_BATTLE)
	e0:SetLabelObject(at)
	tc:RegisterEffect(e0,true)
end
function s.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	if Duel.ChangePosition(tc,pos)~=0 and tc:IsFaceup() then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.descon)
		e1:SetOperation(s.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id+1000)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetLabelObject(),POS_FACEDOWN)
end
