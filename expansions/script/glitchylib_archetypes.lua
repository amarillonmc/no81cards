GLITCHYLIB_ARCHETYPES_LOADED					= true

--ARCHETYPE : DESPERADO TRICKSTER
if GLITCHYLIB_DESPERADO_TRICKSTER_LOADED and not GLITCHYLIB_DESPERADO_TRICKSTER_ALREADY_READ then
	GLITCHYLIB_DESPERADO_TRICKSTER_ALREADY_READ = true
	if not GLITCHYLIB_LOADED then
		Duel.LoadScript("glitchylib_vsnemo.lua")
	end
	
	EVENT_DESPERADO_CHALLENGED = EVENT_CUSTOM+CARD_DESPERADO_TRICKSTER_THE_FORERUNNER
	
	----Register the on-Summon effect of Desperado Trickster monsters that can be challenged by the opponent
	function Auxiliary.RegisterDesperadoChallengeEffect(c,id,cat,prop,target,op,challenge,ignore_hopt)
		if not cat then cat=0 end
		
		local e1=Effect.CreateEffect(c)
		e1:Desc(0)
		e1:SetCategory(cat|CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
		if prop then
			e1:SetProperty(prop)
		end
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		if not ignore_hopt then
			e1:HOPT(nil,2)
		end
		e1:SetTarget(aux.DesperadoChallengeTarget(target,prop and prop&EFFECT_FLAG_CARD_TARGET>0))
		e1:SetOperation(aux.DesperadoChallengeOperation(id,aux.CreateDesperadoChallenge(challenge),op))
		c:RegisterEffect(e1)
		local e2=e1:SpecialSummonEventClone(c)
		return e1,e2
	end
	
	function Auxiliary.DesperadoChallengeTarget(target,tgchk)
		if not tgchk then
			return	function(e,tp,eg,ep,ev,re,r,rp,chk)
						if chk==0 then return target(e,tp,eg,ep,ev,re,r,rp,0) end
						target(e,tp,eg,ep,ev,re,r,rp,chk)
						local c=e:GetHandler()
						local p,loc=c:GetResidence()
						Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,c,1,p,loc)
					end
		else
			return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
						if chk==0 then return target(e,tp,eg,ep,ev,re,r,rp,0) end
						target(e,tp,eg,ep,ev,re,r,rp,chk)
						local c=e:GetHandler()
						local p,loc=c:GetResidence()
						Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,c,1,p,loc)
					end
		end
	end
	
	function Auxiliary.DesperadoChallengeOperation(id,challenge_function,op)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,1))
					local challenge_accepted = Duel.IsPlayerAffectedByEffect(1-tp,CARD_DESPERADO_TRICKSTER_THE_FORERUNNER) and 2 or Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) and 1 or 0
					if challenge_accepted>0 then
						if challenge_accepted==2 then
							Duel.Hint(HINT_CARD,tp,CARD_DESPERADO_TRICKSTER_THE_FORERUNNER)
						end
						Duel.RaiseEvent(e:GetHandler(),EVENT_DESPERADO_CHALLENGED,e,0,1-tp,1-tp,0)
						challenge_function(e,tp,eg,ep,ev,re,r,rp)
					else
						op(e,tp,eg,ep,ev,re,r,rp)
					end
				end
	end
	
	function Auxiliary.CreateDesperadoChallenge(challenge)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					if challenge(e,tp,eg,ep,ev,re,r,rp,0) then
						challenge(e,tp,eg,ep,ev,re,r,rp,1)
					else
						Duel.Destroy(e:GetHandler(),REASON_EFFECT)
					end
				end
	end
	
	----Register Geas-generating effect
	Auxiliary.GeasHints={}
	function Auxiliary.RegisterDesperadoGeasGenerationEffect(c,id,prop,target,op,...)
		local code=c:IsOriginalType(TYPE_LINK) and EVENT_SPSUMMON_SUCCESS or EVENT_SUMMON_SUCCESS
		local e1=Effect.CreateEffect(c)
		e1:Desc(0)
		e1:SetCategory(CATEGORIES_TOKEN|CATEGORY_COUNTER|CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
		if prop then
			e1:SetProperty(prop)
		end
		e1:SetCode(code)
		e1:SetTarget(aux.DesperadoGeasGenerationTarget(target))
		e1:SetOperation(aux.DesperadoGeasGenerationOperation(id,op,...))
		c:RegisterEffect(e1)
		if code~=EVENT_SPSUMMON_SUCCESS then
			local e2=e1:SpecialSummonEventClone(c)
			return e1,e2
		end
		
		if not aux.GeasHintCheck then
			aux.GeasHintCheck=true
			local ge=Effect.CreateEffect(c)
			ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge:SetCode(EVENT_ADJUST)
			ge:SetCondition(aux.DesperadoGeasGenerationCondition)
			ge:SetOperation(aux.DesperadoGeasHintReset)
			Duel.RegisterEffect(ge,0)
		end
		
		return e1
	end
	function Auxiliary.DesperadoGeasGenerationCondition(e)
		return #aux.GeasHints>0 and not Duel.IsExistingMatchingCard(aux.DesperadoGeasLingeringResetFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	function Auxiliary.DesperadoGeasGenerationTarget(target)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						return Duel.CheckDesperadoHeartCardForGeas(tp,nil,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
					end
					Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,COUNTER_GEAS)
					Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
					Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
					Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
					if target then
						target(e,tp,eg,ep,ev,re,r,rp,chk)
					end
				end
	end
	function Auxiliary.DesperadoGeasGenerationOperation(id,op,...)
		local funs={...}
		return	function(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,1))
					local g=Duel.GetDesperadoHeartCard(tp,aux.DesperadoHeartGeasFilter(nil),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,HINTMSG_FACEUP)
					if #g>0 then
						Duel.HintSelection(g)
						local c=e:GetHandler()
						local tc=g:GetFirst()
						if tc:IsFaceup() and tc:IsCanAddCounter(COUNTER_GEAS,1) and tc:AddCounter(COUNTER_GEAS,1) and Duel.SelectYesNo(1-tp,aux.Stringid(33720107,3)) then
							Duel.BreakEffect()
							Duel.Destroy(tc,REASON_EFFECT,LOCATION_GRAVE,1-tp)
						end
						if Duel.IsExistingMatchingCard(aux.DesperadoGeasLingeringResetFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
							for _,f in ipairs(funs) do
								local e1,opporeg=f(c)
								local cond=e1:GetCondition()
								e1:SetCondition(aux.DesperadoGeasLingeringReset(cond))
								Duel.RegisterEffect(e1,tp)
								if opporeg then
									local e2=e1:Clone()
									Duel.RegisterEffect(e2,1-tp)
								end
								
								local desc=e1:GetDescription()
								if desc then
									local h=Effect.CreateEffect(c)
									h:SetDescription(desc)
									h:SetType(EFFECT_TYPE_FIELD)
									h:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
									h:SetCode(EFFECT_FLAG_EFFECT+id)
									h:SetTargetRange(1,0)
									Duel.RegisterEffect(h,tp)
									table.insert(aux.GeasHints,h)
								end
							end
						end
					end
					if op then
						op(e,tp,eg,ep,ev,re,r,rp)
					end
				end
	end
	
	function Auxiliary.DesperadoGeasLingeringReset(cond)
		return	function(e,...)
					if not Duel.IsExistingMatchingCard(aux.DesperadoGeasLingeringResetFilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
						e:Reset()
						return false
					end
					return (not cond or cond(e,...))
				end
	end
	function Auxiliary.DesperadoGeasLingeringResetFilter(c)
		return c:IsFaceup() and c:IsSetCard(ARCHE_DESPERADO_HEART) and c:GetCounter(COUNTER_GEAS)>0
	end
	
	function Auxiliary.DesperadoGeasHintReset(e,tp,eg,ep,ev,re,r,rp)
		local ct=#aux.GeasHints
		while ct>0 do
			aux.GeasHints[ct]:Reset()
			table.remove(aux.GeasHints)
			ct=#aux.GeasHints
		end
	end
	
	----Select "Desperado Heart" OR spawn "Desperado Heart Token"
	function Duel.CheckDesperadoHeartCardForGeas(tp,f,loc1,loc2,min,exc,...)
		local f=aux.DesperadoHeartGeasFilter(f)
		if Duel.IsExistingMatchingCard(f,tp,loc1,loc2,min,exc,...) then return true end
		if not Duel.IsCanAddCounter(tp) then return false end
		for p=tp,1-tp,1-2*tp do
			if Duel.GetMZoneCount(p,nil,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_DESPERADO_HEART,ARCHE_DESPERADO_HEART,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE,POS_FACEUP,p) then
				return true
			end
		end
		return false
	end
	
	function Duel.GetDesperadoHeartCard(tp,f,loc1,loc2,min,max,exc,hintmsg,...)
		local f=aux.DesperadoHeartFilter(f)
		if Duel.IsExistingMatchingCard(f,tp,loc1,loc2,min,exc,...) then
			Duel.Hint(HINT_SELECTMSG,tp,hintmsg)
			return Duel.SelectMatchingCard(tp,f,tp,loc1,loc2,min,max,exc,...)
		else
			if loc2==0 then
				if Duel.GetMZoneCount(tp)<min or not Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_DESPERADO_HEART,ARCHE_DESPERADO_HEART,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE) then return end
				local g=Group.CreateGroup()
				for i=1,min do
					local token=Duel.CreateToken(tp,TOKEN_DESPERADO_HEART)
					if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
						g:AddCard(token)
					end
				end
				return g
			else
				local checks={false,false}
				for p=tp,1-tp,1-2*tp do
					if Duel.GetMZoneCount(p,nil,tp)>=min and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_DESPERADO_HEART,ARCHE_DESPERADO_HEART,TYPES_TOKEN_MONSTER,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE,POS_FACEUP,p) then
						checks[p+1]=true
					end
				end
				if not checks[1] and not checks[2] then return end
				local opt=aux.Option(tp,33720107,6,checks[tp+1],checks[2-tp])
				local receiver=opt==0 and tp or 1-tp
				local g=Group.CreateGroup()
				for i=1,min do
					local token=Duel.CreateToken(tp,TOKEN_DESPERADO_HEART)
					if Duel.SpecialSummon(token,0,tp,receiver,false,false,POS_FACEUP)>0 then
						g:AddCard(token)
					end
				end
				return g
			end
		end
	end
	
	function Auxiliary.DesperadoHeartFilter(f)
		return	function(c,...)
					return c:IsCode(CARD_DESPERADO_HEART) and (not f or f(c,...))
				end
	end
	function Auxiliary.DesperadoHeartGeasFilter(f)
		return	function(c,...)
					return c:IsFaceup() and c:IsCode(CARD_DESPERADO_HEART) and c:GetCounter(COUNTER_GEAS)==0 and c:IsCanAddCounter(COUNTER_GEAS,1) and (not f or f(c,...))
				end
	end
	
	----Special Summon "Desperado" Continuous Spells as monsters with effects
	function Auxiliary.RegisterDesperadoSpellMonsterEffect(c,id,counter,op)
		local e=Effect.CreateEffect(c)
		e:Desc(2)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetType(EFFECT_TYPE_IGNITION)
		e:SetRange(LOCATION_SZONE)
		e:SetCondition(function(E) return not E:GetHandler():HasFlagEffect(id) end)
		e:SetCost(aux.DummyCost)
		e:SetTarget(aux.DesperadoSpellMonsterTarget(counter))
		e:SetOperation(aux.DesperadoSpellMonsterOperation(counter,op))
		c:RegisterEffect(e)
		return e
	end
	function Auxiliary.DesperadoSpellMonsterTarget(counter)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return e:IsCostChecked() and Duel.GetMZoneCount(tp)>0
						and Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_DESPERADO_HEART,ARCHE_DESPERADO_HEART,TYPE_MONSTER|TYPE_EFFECT,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE)
					end
					local c=e:GetHandler()
					local ct=c:GetCounter(counter)
					Duel.SetTargetParam(ct)
					Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
				end
	end
	function Auxiliary.DesperadoSpellMonsterOperation(counter,op)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					if not Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_DESPERADO_HEART,ARCHE_DESPERADO_HEART,TYPE_MONSTER|TYPE_EFFECT,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE) then return end
					c:AddMonsterAttribute(TYPE_EFFECT)
					if Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP) then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_IGNORE_IMMUNE)
						e1:SetCode(EFFECT_CHANGE_CODE)
						e1:SetValue(CARD_DESPERADO_HEART)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
						c:RegisterEffect(e1,true)
					end
					if Duel.SpecialSummonComplete()>0 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
						local ct=Duel.GetTargetParam()
						if ct and ct>0 then
							c:AddCounter(counter,ct)
						end
					end
					if op then
						op(c,e,tp,eg,ep,ev,re,r,rp)
					end
				end
	end
end

--ARCHETYPE : K.E.Y FRAGMENTS
if GLITCHYLIB_KEYFRAGMENT_LOADED and not GLITCHYLIB_KEYFRAGMENT_ALREADY_READ then
	GLITCHYLIB_KEYFRAGMENT_ALREADY_READ = true
	if not GLITCHYLIB_LOADED then
		Duel.LoadScript("glitchylib_vsnemo.lua")
	end
	if not STICKERS_LOADED then
		Duel.LoadScript("stickers.lua")
	end
	
	----Register the Sticker-placing K.E.Y. Fragment Quick Effect that activates from the hand by discarding the activator and paying LP
	function Auxiliary.RegisterKeyFragmentStickerQE(c,lpcost,sticker)
		local e1=Effect.CreateEffect(c)
		e1:Desc(11)
		e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_HAND)
		e1:SetRelevantTimings()
		e1:SetFunctions(aux.MainPhaseCond(),aux.KeyFragmentStickerQECost(lpcost),aux.KeyFragmentStickerQETarget(sticker),aux.KeyFragmentStickerQEOperation(sticker))
		c:RegisterEffect(e1)
		return e1
	end
	function Auxiliary.KeyFragmentStickerQEFilter(c,sticker,e,tp,REASON_EFFECT)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY) and c:IsCanAddSticker(sticker,1,e,tp,REASON_EFFECT)
	end
	function Auxiliary.KeyFragmentStickerQECost(lpcost)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						return c:IsDiscardable() and Duel.CheckLPCost(tp,lpcost)
					end
					Duel.SendtoGrave(c,REASON_COST|REASON_DISCARD)
					Duel.PayLPCost(tp,lpcost)
				end
	end
	function Auxiliary.KeyFragmentStickerQETarget(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and aux.KeyFragmentStickerQEFilter(chkc,sticker,e,tp,REASON_EFFECT) end
						if chk==0 then
							return Duel.IsExists(true,aux.KeyFragmentStickerQEFilter,tp,LOCATION_MZONE,0,1,nil,sticker,e,tp,REASON_EFFECT)
						end
						local g=Duel.Select(HINTMSG_TARGET,true,tp,aux.KeyFragmentStickerQEFilter,tp,LOCATION_MZONE,0,1,1,nil,sticker,e,tp,REASON_EFFECT)
						Duel.SetCustomOperationInfo(0,CATEGORY_PLACE_STICKER,g,#g,0,0,sticker,1)
					end
	end
	function Auxiliary.KeyFragmentStickerQEOperation(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp)
						local tc=Duel.GetFirstTarget()
						if tc:IsRelateToChain() then
							tc:AddSticker(sticker,1,e,tp,REASON_EFFECT)
						end
					end
	end
	
	----Register the non-activated Sticker-placing K.E.Y. Fragment effects
	function Auxiliary.RegisterKeyFragmentStickerContinuous(c,id,sticker_self,sticker_oppo)
		local e1=Effect.CreateEffect(c)
		e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(aux.KeyFragmentPlaceStickerOnItself(sticker_self))
		c:RegisterEffect(e1)
		local e2=e1:SpecialSummonEventClone(c)
		local reg=Effect.CreateEffect(c)
		reg:SetType(EFFECT_TYPE_SINGLE)
		reg:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		reg:SetCode(33730147)
		reg:SetValue(sticker_self)
		c:RegisterEffect(reg)
		
		local e3=Effect.CreateEffect(c)
		e3:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetCondition(aux.KeyFragmentOncePerBattle(id))
		e3:SetOperation(aux.KeyFragmentPlaceStickerOnOpponentCard(sticker_oppo,id,12))
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLE_DESTROYING)
		e4:SetCondition(aux.AND(aux.bdocon,aux.KeyFragmentOncePerBattle(id)))
		e4:SetOperation(aux.KeyFragmentPlaceStickerOnOpponentCard(sticker_oppo,id,12))
		c:RegisterEffect(e4)
		return e1,e2,e3,e4
	end
	
	function Auxiliary.KeyFragmentPlaceStickerOnItself(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
					local c=e:GetHandler()
					c:AddSticker(sticker,1,e,tp,REASON_EFFECT)
				end
	end
	function Auxiliary.KeyFragmentOncePerBattle(id)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return not e:GetHandler():HasFlagEffect(id)
				end
	end
	function Auxiliary.KeyFragmentPlaceStickerOnOpponentCard(sticker,id,desc)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.IsExists(false,Card.IsCanAddSticker,tp,0,LOCATION_ONFIELD,1,nil,sticker,1,e,tp,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,desc)) then
						local c=e:GetHandler()
						c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE_CAL,0,1)
						Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
						local tc=Duel.Select(HINTMSG_OPERATECARD,false,tp,Card.IsCanAddSticker,tp,0,LOCATION_ONFIELD,1,1,nil,sticker,1,e,tp,REASON_EFFECT):GetFirst()
						if tc then
							Duel.HintSelection(Group.FromCards(tc))
							tc:AddSticker(sticker,1,e,tp,REASON_EFFECT)
						end
					end
				end
	end
end